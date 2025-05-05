resource "google_bigquery_table" "weather_daily" {
  deletion_protection = false
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "weather_daily"
  project    = var.project_id

  schema = jsonencode([
    { name = "date", type = "DATE", mode = "REQUIRED" },
    { name = "temperature_mean", type = "FLOAT", mode = "NULLABLE" },
    { name = "precipitation", type = "FLOAT", mode = "NULLABLE" },
    { name = "cloud_cover", type = "FLOAT", mode = "NULLABLE" },
    { name = "wind_speed", type = "FLOAT", mode = "NULLABLE" }
  ])

  time_partitioning {
    type  = "DAY"
    field = "date"
  }
}


resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  location   = var.dataset_location
}

resource "google_bigquery_dataset" "chicago_analytics_staging" {
  dataset_id = "chicago_analytics_staging"
  location   = var.dataset_location
}

resource "google_bigquery_dataset" "chicago_analytics_marts" {
  dataset_id = "chicago_analytics_marts"
  location   = var.dataset_location
}
