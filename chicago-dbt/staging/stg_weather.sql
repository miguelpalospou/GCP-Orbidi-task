{{ config(materialized='table') }}
SELECT
  DATE(date) AS date,
  temperature_mean,
  precipitation,
  wind_speed,
  cloud_cover
FROM `orbidi-458404.raw.weather_daily`
