variable "region" {}
variable "function_url" {}

resource "google_cloud_scheduler_job" "trigger_weather_ingestion" {
  name     = "weather-daily-trigger"
  schedule = "0 6 * * *"
  time_zone = "America/Chicago"

  http_target {
    uri        = var.function_url
    http_method = "GET"
  }

  region = var.region
}
