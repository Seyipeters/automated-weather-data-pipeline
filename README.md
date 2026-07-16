# Automated Weather Data Pipeline

## Overview

Production-style data engineering project that extracts weather data from a public API, stores raw JSON files in AWS S3, loads the data into Snowflake, transforms it with dbt, applies data quality checks, and prepares a clean mart for Power BI reporting.

This project demonstrates API ingestion, cloud storage, Snowflake semi-structured data loading, dbt transformations, source freshness, data quality testing, and analytics-ready modeling.

---

## Architecture

![Architecture Diagram](screenshots/01_architecture.png)

```text
Weather API
    ↓
Python ingestion script
    ↓
AWS S3 raw bucket
    ↓
Snowflake RAW.WEATHER_OBSERVATIONS
    ↓
dbt staging + intermediate models
    ↓
mart_daily_weather_summary
    ↓
Power BI dashboard
```

---

## Tech Stack

| Area | Tools |
|---|---|
| Ingestion | Python, requests |
| Cloud Storage | AWS S3 |
| Data Warehouse | Snowflake |
| Transformation | dbt Core, SQL |
| Data Quality | dbt tests, source freshness |
| Documentation | dbt Docs |
| Reporting | Power BI |
| Version Control | Git, GitHub |

---

## What This Project Does

- Extracts weather data from a public Weather API
- Saves raw API responses as JSON files
- Uploads raw JSON files to AWS S3 using Boto3
- Loads semi-structured JSON data into Snowflake
- Stores raw API responses in a Snowflake `VARIANT` column
- Uses dbt to flatten nested JSON arrays into tabular records
- Separates valid and invalid records
- Builds a daily weather summary mart for reporting
- Adds dbt tests and source freshness checks
- Generates dbt documentation and lineage

---

## Data Pipeline Layers

| Layer | Object | Purpose |
|---|---|---|
| Raw Storage | AWS S3 raw bucket | Stores original JSON API files |
| Snowflake RAW | `RAW.WEATHER_OBSERVATIONS` | Stores raw JSON as `VARIANT` with metadata |
| dbt Staging | `stg_weather_observations` | Flattens hourly JSON weather arrays |
| dbt Intermediate | `int_valid_weather_observations` | Keeps valid business-ready records |
| dbt Intermediate | `int_bad_weather_observations` | Stores rejected or suspicious records |
| dbt Mart | `mart_daily_weather_summary` | Daily city-level weather reporting table |

---

## Data Quality

The project includes dbt tests for:

- Non-null city and observation time
- Non-null temperature, humidity, precipitation, and wind speed
- Humidity between 0 and 100
- No negative precipitation
- No negative wind speed
- No null reporting metrics in the final mart

dbt source freshness checks whether `RAW.WEATHER_OBSERVATIONS` has been loaded recently using the `loaded_at` column.

---

## Final Mart

The final reporting model is:

```text
mart_daily_weather_summary
```

It provides daily weather metrics by city:

- Total hourly records
- Average temperature
- Minimum temperature
- Maximum temperature
- Average humidity
- Total precipitation
- Average wind speed

Power BI connects to this dbt-created mart instead of raw JSON tables.

---

## Screenshots<img width="943" height="550" alt="stg_weather_observations" src="https://github.com/user-attachments/assets/3f97a9ba-261c-490c-87c4-42c2fac60afd" />


### dbt Docs Overview

![Uploading stg_weather_observations.png…]()

### dbt Lineage Graph

<img width="929" height="514" alt="lineage_graph" src="https://github.com/user-attachments/assets/5a1a6497-4b92-41cf-a2e3-3f8f446807a8" />


### Weather Mart

<img width="945" height="529" alt="mart_daily_weather_summary" src="https://github.com/user-attachments/assets/4758c315-a89f-4047-86b7-1e6ad2610d57" />


### Int Valid Weather Observations
<img width="947" height="531" alt="int_valid_weather_observations" src="https://github.com/user-attachments/assets/9932aa3c-f0d5-47d3-a0c0-e99533fc5c3f" />


---

## Project Structure

```text
automated-weather-data-pipeline/
├── src/
│   ├── cities.py
│   ├── extract_weather.py
│   └── upload_to_s3.py
├── sql/
│   └── 01_snowflake_raw_setup.sql
├── dbt/
│   └── weather_dbt/
│       ├── models/
│       │   ├── staging/
│       │   ├── intermediate/
│       │   └── marts/
│       └── tests/
├── screenshots/
├── docs/
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md

## Key Skills Demonstrated

- Python API ingestion
- AWS S3 raw data storage
- Boto3 file upload
- Snowflake external stage
- Snowflake JSON/VARIANT loading
- Semi-structured data transformation
- dbt staging, intermediate, and mart modeling
- Snowflake `LATERAL FLATTEN`
- dbt tests and source freshness
- Bad records audit model
- dbt docs and lineage
- Power BI reporting-ready mart
- Git/GitHub project organization
