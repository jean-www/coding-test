# TODO: Import aiohttp, asyncio, and config
import aiohttp, asyncio
from config import OPENWEATHER_API_KEY, WEATHERAPI_API_KEY 

async def fetch_openweather(city):
    # TODO: Implement async fetch for OpenWeather API
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={OPENWEATHER_API_KEY}"
    connector = aiohttp.TCPConnector(ssl=False)
    async with aiohttp.ClientSession(connector=connector) as session:
        async with session.get(url) as resp:
            resp.raise_for_status()
            return await resp.json()

async def fetch_weatherapi(city):
    # TODO: Implement async fetch for WeatherAPI
    url = f"https://api.weatherapi.com/v1/current.json?key={WEATHERAPI_API_KEY}&q={city}"
    connector = aiohttp.TCPConnector(ssl=False)
    async with aiohttp.ClientSession(connector=connector) as session:
        async with session.get(url) as resp:
            resp.raise_for_status()
            return await resp.json()

async def fetch_all_weather(cities):
    # TODO: Use asyncio.gather to fetch concurrently from both APIs for all cities
    tasks = []
    for city in cities:
        tasks.append(fetch_weatherapi(city))
        tasks.append(fetch_openweather(city))
    return await asyncio.gather(*tasks)
