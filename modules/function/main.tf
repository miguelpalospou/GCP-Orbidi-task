variable "bucket_name" {}
variable "region" {}
variable "function_zip_source" {}
variable "project_id" {}

resource "google_storage_bucket" "function_code_bucket" {
  name     = var.bucket_name
  location = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "weather_function.zip"
  bucket = google_storage_bucket.function_code_bucket.name
  source = var.function_zip_source
}

resource "google_cloudfunctions_function" "weather_ingest" {
  name        = "weather-ingest-fn"
  runtime     = "python310"
  entry_point = "ingest_weather"
  region      = var.region

  source_archive_bucket = google_storage_bucket.function_code_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name

  trigger_http = true
  available_memory_mb = 512
  timeout             = 120

  environment_variables = {
    PROJECT_ID = var.project_id
    DATASET    = "raw"
    TABLE      = "weather_daily"
  }
}

output "function_url" {
  value = google_cloudfunctions_function.weather_ingest.https_trigger_url
}
