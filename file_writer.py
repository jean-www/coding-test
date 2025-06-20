import os
import csv
import json

def write_to_csv(data, filename="weather-app-output/weather_data.csv"):
    # TODO: Write or append to CSV with headers
    file_exists = os.path.isfile(filename)
    with open(filename, mode="a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=data[0].keys())
        if not file_exists:
            writer.writeheader()
        writer.writerows(data)


def write_to_json(data, filename="./weather-app-output/weather_data.json"):
    # TODO: Read existing JSON (if any), append data, and write back
    existing = []
    if os.path.isfile(filename):
        with open(filename, "r", encoding="utf-8") as f:
            existing = json.load(f)
    existing.extend(data)
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(existing, f, ensure_ascii=False, indent=2)
