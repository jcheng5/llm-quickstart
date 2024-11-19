import requests
from chatlas import ChatAnthropic
from dotenv import load_dotenv

load_dotenv()  # Loads OPENAI_API_KEY from the .env file

chat = ChatAnthropic(
    model="claude-3-5-sonnet-latest",
    system_prompt=(
        "You are a helpful assistant that can check the weather. "
        "Report results in imperial units."
    ),
)


# Define a simple tool for getting the current weather
def get_weather(latitude: float, longitude: float):
    """
    Get the current weather for a location using latitude and longitude.
    """
    base_url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "current": "temperature_2m,wind_speed_10m,relative_humidity_2m",
    }

    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()  # Raise an exception for bad status codes
        return response.text
    except requests.RequestException as e:
        return f"Error fetching weather data: {str(e)}"


chat.register_tool(get_weather)
print(chat.chat("What is the weather in Seattle?"))
