{{ config(materialized='view') }}

SELECT
    city,
    country,
    DATE_TRUNC('day', observation_time::TIMESTAMP_NTZ) AS observation_date,
    COUNT(*) AS total_hourly_records,
    ROUND(AVG(temperature_2m), 2) AS avg_temperature_2m,
    ROUND(MIN(temperature_2m), 2) AS min_temperature_2m,
    ROUND(MAX(temperature_2m), 2) AS max_temperature_2m,
    ROUND(AVG(relative_humidity_2m), 2) AS avg_relative_humidity_2m,
    ROUND(SUM(precipitation), 2) AS total_precipitation,
    ROUND(AVG(wind_speed_10m), 2) AS avg_wind_speed_10m
FROM {{ ref('int_valid_weather_observations') }}
GROUP BY 1, 2, 3
