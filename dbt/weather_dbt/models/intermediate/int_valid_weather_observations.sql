{{ config(materialized='view') }}

SELECT *
FROM {{ ref('stg_weather_observations') }}
WHERE city IS NOT NULL
  AND observation_time IS NOT NULL
  AND temperature_2m IS NOT NULL
  AND relative_humidity_2m IS NOT NULL
  AND precipitation IS NOT NULL
  AND wind_speed_10m IS NOT NULL
