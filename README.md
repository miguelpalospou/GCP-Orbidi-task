# GCP Chicago Weather Analytics Pipeline

This project sets up a serverless data pipeline using:
- **Terraform** for infrastructure on GCP
- **Cloud Functions** for scheduled data ingest
- **BigQuery** for storage and analysis
- **DBT** for transforming raw weather data into analytics-ready models

---

## 💡 Project Overview

This project automates the deployment of a data pipeline on **Google Cloud Platform (GCP)** using **Terraform**, **BigQuery**, **Cloud Functions**, and **Cloud Scheduler**.

We ingest, process, and enrich data from the **City of Chicago’s public datasets**, including weather data, to power analytical use cases.

---

## 📊 Project Context

The City of Chicago offers rich public datasets such as:

- **trips information**
- **Traffic accidents**
- **Inspections**
- And more…

We enhance this data by integrating **daily weather information**, fetched via a Cloud Function, and organize it into BigQuery datasets structured as:

- `raw`: Ingested unprocessed data
- `staging`: Cleaned and prepared for modeling
- `mart`: Final analytical tables

### 🔧 Infrastructure
- Deploys datasets in BigQuery (`raw`, `chicago_analytics_staging`, `chicago_analytics_marts`)
- Cloud Function to pull weather data from API (e.g., NOAA or other)
- Cloud Scheduler to run the function daily
- IAM roles for secure access

### 🧠 Data Flow
1. Cloud Scheduler triggers Cloud Function
2. Cloud Function fetches weather data and writes to `raw.weather_daily`
3. DBT transforms data in `staging/` and `marts/` layers

### 🌤 Summary of What This Function Does
1. Fetches historical weather data for each day between June and December 2023.
2. Uses the Open-Meteo Archive API to get:

- Mean temperature
- Precipitation
- Cloud cover
- Wind speed
- Builds a pandas DataFrame from the results.
- Uploads it to BigQuery, overwriting the table each time it runs.

📐 Architecture Overview

![image](https://github.com/user-attachments/assets/aa7cf39e-12fe-4898-a6e8-f5f5e1b96677)

![image](https://github.com/user-attachments/assets/7fdf835f-2edd-4252-a322-7a5c9359281b)

![image](https://github.com/user-attachments/assets/516dc248-5309-4ced-96eb-98ae327c0860)


# 🛠️ Terraform Structure and Explanation

This project uses Terraform to automate the deployment of a cloud data pipeline that ingests historical weather data for Chicago and stores it in BigQuery. Below is a detailed breakdown of each `.tf` file and module used in this setup.

---

## 📁 Root Files

### `main.tf`
- Entry point of the Terraform configuration.
- Configures the Google provider and references all modules: `storage`, `bq`, `function`, `scheduler`, and `iam`.
- Sets project-wide variables such as project ID and region.

### `variables.tf`
- Declares all variables used throughout the Terraform modules such as:
  - Project ID
  - Region
  - Dataset name
  - Table name
- Provides default values and descriptions.

### `outputs.tf`
- Exposes useful output values after applying Terraform.
- Typically includes:
  - Bucket names
  - Cloud Function URLs
  - Dataset or table info

---

## 📦 Modules

### `modules/storage/`

**Purpose**: Creates a Cloud Storage bucket used to store the source code for the Cloud Function.

#### `main.tf`
- Defines a `google_storage_bucket` resource.
- This bucket is used by the Cloud Function deployment to upload the zipped function code.

---

### `modules/bq/`

**Purpose**: Sets up a BigQuery dataset and table for storing weather data.

#### `main.tf`
- Creates a dataset using `google_bigquery_dataset`.
- Creates a table using `google_bigquery_table`, including schema definitions for:
  - Date
  - Mean temperature
  - Precipitation
  - Cloud cover
  - Wind speed

---

### `modules/function/`

**Purpose**: Deploys a Cloud Function that fetches weather data and loads it into BigQuery.

#### `main.tf`
- Defines a `google_cloudfunctions2_function` with an HTTP trigger.
- Sets environment variables: project ID, dataset, table.
- Connects to the code stored in the storage bucket.
- Configures execution roles and permissions.

---

### `modules/scheduler/`

**Purpose**: Schedules the execution of the Cloud Function.

#### `main.tf`
- Creates a `google_cloud_scheduler_job`.
- Uses HTTP target to call the function's endpoint.
- Schedule is configurable using a CRON expression.

---

### `modules/iam/`

**Purpose**: Manages IAM role bindings for required identities.

#### `main.tf`
- Assigns roles to:
  - Your user (e.g., `miguelpalospou`)
  - The auto-generated Compute Engine service account (e.g., `PROJECT_NUMBER-compute@developer.gserviceaccount.com`)
- Roles include:
  - `Artifact Registry Administrator`
  - `Artifact Registry Reader`
  - `Artifact Registry Writer`
  - `BigQuery Recommender Project Viewer`
  - `Cloud Build Editor`
  - `Cloud Functions Admin`
  - `Logs Viewer`
  - `Logs Writer`
  - `Storage Object Viewer`

Ensures all components have permission to read/write GCS, execute functions, and load data to BigQuery.
---


### 🛠 Prerequisites
- Terraform CLI
- Python 3.10
- gcloud SDK
- DBT (BigQuery adapter)

### 🌍 Set Environment
```bash
export GOOGLE_CLOUD_PROJECT="your-project-id"
export GOOGLE_REGION="us-central1"

### 📦 Deploy Infrastructure

cd terraform
terraform init
terraform apply

### Cloud Function Packaging

cd function-code
zip -r ../weather_function.zip main.py requirements.txt
cd ..

### Run DBT

cd chicago-dbt
dbt run
