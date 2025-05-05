-- models/marts/trips_weather_join.sql
{{ config(materialized='table') }}

WITH taxi AS (
  SELECT
    trip_id,
    DATE(trip_start_timestamp) AS trip_date,
    trip_seconds,
  FROM {{ ref('stg_chicago_taxi') }}
),
weather AS (
  SELECT
    date AS trip_date,
  temperature_mean,
  precipitation,
  wind_speed,
  cloud_cover
  FROM {{ ref('stg_weather') }}
)

SELECT
  t.trip_id,
  t.trip_date,
  t.trip_seconds,
  w.temperature_mean,
  w.wind_speed,
  w.cloud_cover,
  w.precipitation,
FROM taxi t
JOIN weather w ON t.trip_date = w.trip_date
