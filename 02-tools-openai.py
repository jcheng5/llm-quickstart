import json
import sys

import requests
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

# Initialize the OpenAI client
client = OpenAI()


# Define a simple tool for getting the current weather
def get_weather(latitude, longitude):
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


# Define the tool for the API
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get the current weather for a location using latitude and longitude",
            "parameters": {
                "type": "object",
                "properties": {
                    "latitude": {
                        "type": "number",
                        "description": "The latitude coordinate",
                    },
                    "longitude": {
                        "type": "number",
                        "description": "The longitude coordinate",
                    },
                },
                "required": ["latitude", "longitude"],
            },
        },
    }
]


def process_conversation(messages):
    while True:
        response = client.chat.completions.create(
            model="gpt-4o",  # Make sure to use a model that supports function calling
            messages=messages,
            tools=tools,
            tool_choice="auto",
        )

        message = response.choices[0].message
        messages.append(message.model_dump())

        if not message.tool_calls:
            # If there are no tool calls, we're done
            return message.content

        # Process all tool calls
        for tool_call in message.tool_calls:
            function_name = tool_call.function.name
            function_args = json.loads(tool_call.function.arguments)

            if function_name == "get_weather":
                latitude = function_args.get("latitude")
                longitude = function_args.get("longitude")
                content = get_weather(latitude, longitude)
            else:
                # If the function is unknown, return an error message
                # and also log to stderr
                content = f"Unknown function: {function_name}"
                print(f"Unknown function: {function_name}", file=sys.stderr)

            messages.append(
                {
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "name": function_name,
                    "content": content,
                }
            )


# Initial conversation
messages = [
    {
        "role": "system",
        "content": "You are a helpful assistant that can check the weather. Report results in imperial units.",
    },
    {
        "role": "user",
        "content": "What's the weather like in Seattle?",
    },
]

# Start the conversation and process any tool calls
final_response = process_conversation(messages)

print("Final response:", final_response)
