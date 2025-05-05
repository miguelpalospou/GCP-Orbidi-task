
-- models/staging/stg_chicago_taxi.sql
{{ config(
    materialized='table',
    partition_by={
      'field': 'trip_start_timestamp',
      'data_type': 'timestamp',
      'granularity': 'day'
    }
) }}

SELECT
  unique_key as trip_id,
  trip_start_timestamp,
  trip_end_timestamp,
  trip_seconds,
  trip_miles,
  pickup_community_area,
  dropoff_community_area,
  fare,
  tips,
  tolls,
  payment_type,
  company
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE trip_start_timestamp BETWEEN TIMESTAMP('2023-06-01') AND TIMESTAMP('2023-12-31')
