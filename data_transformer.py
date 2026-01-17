# TODO: Import datetime
from datetime import datetime

def normalize_openweather(data):
    # TODO: Normalize OpenWeather API response
    return {
        "source":       "openweather",
        "city":         data["name"],
        "timestamp":    datetime.utcfromtimestamp(data["dt"]).isoformat(),
        "temperature":  data["main"]["temp"],
        "conditions":   data["weather"][0]["description"]
    }

def normalize_weatherapi(data):
    # TODO: Normalize WeatherAPI response
    current = data["current"]
    return {
        "source":       "weatherapi",
        "city":         data["location"]["name"],
        "timestamp":    data["location"]["localtime"],
        "temperature":  current["temp_c"],
        "conditions":   current["condition"]["text"]
    }

def normalize_responses(response_list):
    # TODO: Detect API source and apply the appropriate normalizer
    normalized = []
    for resp in response_list:
        if resp.get("name") and "main" in resp: # i could use the "source" field as well.
            normalized.append(normalize_openweather(resp))
        elif resp.get("location"):
            normalized.append(normalize_weatherapi(resp))
    return normalized

