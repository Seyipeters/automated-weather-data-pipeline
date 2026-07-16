SELECT *
FROM {{ ref('int_valid_weather_observations') }}
WHERE relative_humidity_2m < 0
   OR relative_humidity_2m > 100
