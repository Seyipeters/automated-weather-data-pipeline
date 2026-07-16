SELECT *
FROM {{ ref('int_valid_weather_observations') }}
WHERE precipitation < 0
