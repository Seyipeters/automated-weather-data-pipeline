{{ config(materialized='view') }}

SELECT
    *,
    CASE
        WHEN city IS NULL THEN 'missing_city'
        WHEN observation_time IS NULL THEN 'missing_observation_time'
        WHEN temperature_2m IS NULL THEN 'missing_temperature'
        WHEN relative_humidity_2m IS NULL THEN 'missing_humidity'
        WHEN precipitation IS NULL THEN 'missing_precipitation'
        WHEN wind_speed_10m IS NULL THEN 'missing_wind_speed'
        ELSE 'unknown_issue'
    END AS issue_type
FROM {{ ref('stg_weather_observations') }}
WHERE city IS NULL
   OR observation_time IS NULL
   OR temperature_2m IS NULL
   OR relative_humidity_2m IS NULL
   OR precipitation IS NULL
   OR wind_speed_10m IS NULL
