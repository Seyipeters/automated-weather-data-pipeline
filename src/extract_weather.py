import json
from datetime import datetime, timezone
from pathlib import Path

import requests

from cities import CITIES


RAW_DIR = Path("data/raw")
RAW_DIR.mkdir(parents=True, exist_ok=True)


def fetch_weather(city: dict) -> dict:
    """
    Fetch hourly weather forecast data from Open-Meteo for one city.
    """

    url = "https://api.open-meteo.com/v1/forecast"

    params = {
        "latitude": city["latitude"],
        "longitude": city["longitude"],
        "hourly": [
            "temperature_2m",
            "relative_humidity_2m",
            "precipitation",
            "wind_speed_10m"
        ],
        "timezone": "auto"
    }

    response = requests.get(url, params=params, timeout=30)
    response.raise_for_status()

    data = response.json()

    return {
        "city": city["city"],
        "country": city["country"],
        "latitude": city["latitude"],
        "longitude": city["longitude"],
        "extracted_at_utc": datetime.now(timezone.utc).isoformat(),
        "source": "open-meteo",
        "raw_response": data
    }


def save_raw_json(city_name: str, data: dict) -> Path:
    """
    Save raw API response as JSON.
    """

    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    safe_city_name = city_name.lower().replace(" ", "_")

    file_path = RAW_DIR / f"weather_{safe_city_name}_{timestamp}.json"

    with file_path.open("w", encoding="utf-8") as file:
        json.dump(data, file, indent=2)

    return file_path


def main() -> None:
    for city in CITIES:
        print(f"Fetching weather for {city['city']}...")

        data = fetch_weather(city)
        file_path = save_raw_json(city["city"], data)

        print(f"Saved: {file_path}")


if __name__ == "__main__":
    main()
