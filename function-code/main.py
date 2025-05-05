import datetime
import requests
import os
import pandas as pd
from google.cloud import bigquery

def ingest_weather(request):
    # Define the date range
    start_date = "2023-06-01"
    end_date = "2023-12-31"

    start_date = datetime.date.fromisoformat(start_date)
    end_date = datetime.date.fromisoformat(end_date)

    # List to store all weather data
    weather_data = []

    # Loop through each day in the date range
    current_date = start_date
    while current_date <= end_date:
        # Format the date
        formatted_date = current_date.isoformat()
        
        # Fetch the weather data for the current day
        url = (
            f"https://archive-api.open-meteo.com/v1/archive?"
            f"latitude=41.8781&longitude=-87.6298"
            f"&daily=temperature_2m_mean,precipitation_sum,cloudcover_mean,windspeed_10m_mean"
            f"&timezone=America%2FChicago"
            f"&start_date={formatted_date}&end_date={formatted_date}"
        )
        
        response = requests.get(url)
        daily = response.json().get("daily", {})
        
        # Check if we received valid data for the day
        if daily:
            row = {
                "date": current_date,
                "temperature_mean": daily.get("temperature_2m_mean", [None])[0],
                "precipitation": daily.get("precipitation_sum", [None])[0],
                "cloud_cover": daily.get("cloudcover_mean", [None])[0],
                "wind_speed": daily.get("windspeed_10m_mean", [None])[0]
            }
            weather_data.append(row)
            print(f"Added weather data for {formatted_date}")
        
        # Move to the next day
        current_date += datetime.timedelta(days=1)

    # Convert to DataFrame
    df = pd.DataFrame(weather_data)

    # Overwrite the table in BigQuery
    bq = bigquery.Client()
    table_id = f"{os.environ['PROJECT_ID']}.{os.environ['DATASET']}.{os.environ['TABLE']}"

    job = bq.load_table_from_dataframe(
        df, table_id, job_config=bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE")
    )
    job.result()  # Wait for the job to complete

    return print("Table overwritten with new weather data!")
