{{ config(materialized='view') }}

WITH source AS (
    SELECT
        raw_data,
        source_file,
        loaded_at
    FROM {{ source('raw', 'WEATHER_OBSERVATIONS') }}
),

flattened AS (
    SELECT
        raw_data:city::STRING AS city,
        raw_data:country::STRING AS country,
        raw_data:latitude::FLOAT AS latitude,
        raw_data:longitude::FLOAT AS longitude,
        raw_data:source::STRING AS source,
        raw_data:extracted_at_utc::TIMESTAMP_TZ AS extracted_at_utc,

        time_values.index AS hour_index,
        time_values.value::STRING AS observation_time,

        raw_data:raw_response:hourly:temperature_2m[time_values.index]::FLOAT AS temperature_2m,
        raw_data:raw_response:hourly:relative_humidity_2m[time_values.index]::FLOAT AS relative_humidity_2m,
        raw_data:raw_response:hourly:precipitation[time_values.index]::FLOAT AS precipitation,
        raw_data:raw_response:hourly:wind_speed_10m[time_values.index]::FLOAT AS wind_speed_10m,

        source_file,
        loaded_at

    FROM source,
    LATERAL FLATTEN(input => raw_data:raw_response:hourly:time) AS time_values
)

SELECT *
FROM flattened
