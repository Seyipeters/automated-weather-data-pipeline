SELECT *
FROM {{ ref('mart_daily_weather_summary') }}
WHERE total_hourly_records IS NULL
   OR avg_temperature_2m IS NULL
   OR min_temperature_2m IS NULL
   OR max_temperature_2m IS NULL
   OR avg_relative_humidity_2m IS NULL
   OR total_precipitation IS NULL
   OR avg_wind_speed_10m IS NULL
