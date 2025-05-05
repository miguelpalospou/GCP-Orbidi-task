# GCP Chicago Weather Analytics Pipeline

This project sets up a serverless data pipeline using:
- **Terraform** for infrastructure on GCP
- **Cloud Functions** for scheduled data ingest
- **BigQuery** for storage and analysis
- **DBT** for transforming raw weather data into analytics-ready models

---

## 💡 Project Overview

### 🔧 Infrastructure
- Deploys datasets in BigQuery (`raw`, `chicago_analytics_staging`, `chicago_analytics_marts`)
- Cloud Function to pull weather data from API (e.g., NOAA or other)
- Cloud Scheduler to run the function daily
- IAM roles for secure access

### 🧠 Data Flow
1. Cloud Scheduler triggers Cloud Function
2. Cloud Function fetches weather data and writes to `raw.weather_daily`
3. DBT transforms data in `staging/` and `marts/` layers

📐 Architecture Overview

![image](https://github.com/user-attachments/assets/aa7cf39e-12fe-4898-a6e8-f5f5e1b96677)

![image](https://github.com/user-attachments/assets/7fdf835f-2edd-4252-a322-7a5c9359281b)

![image](https://github.com/user-attachments/assets/516dc248-5309-4ced-96eb-98ae327c0860)



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
