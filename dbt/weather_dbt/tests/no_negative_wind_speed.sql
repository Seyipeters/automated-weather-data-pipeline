SELECT *
FROM {{ ref('int_valid_weather_observations') }}
WHERE wind_speed_10m < 0
