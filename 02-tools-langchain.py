import requests
from dotenv import load_dotenv
# Choose one of these two
# from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain_core.tools import tool
from langgraph.checkpoint.memory import MemorySaver
from langgraph.prebuilt import create_react_agent

load_dotenv()


@tool
def get_weather(latitude: str, longitude: str) -> str:
    """Get the current weather for a location using latitude and longitude"""
    base_url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "current": "temperature_2m,wind_speed_10m,relative_humidity_2m",
    }

    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        return response.text
    except requests.RequestException as e:
        return f"Error fetching weather data: {str(e)}"


# Initialize components
memory = MemorySaver()

# Choose one of these two
# model = ChatOpenAI(model="gpt-4")
model = ChatAnthropic(model="claude-3-5-sonnet-latest")

# Create the agent with the weather tool
app = create_react_agent(
    model,
    tools=[get_weather],
    messages_modifier=(
        "You are a helpful assistant that can check the weather. "
        "Report results in imperial units."
    ),
    checkpointer=memory,
)

# We have to create a thread ID for the conversation. thread_id is useful if you
# want to have a single agent be able to handle multiple conversations at once;
# we don't care in this example, but it's still required by MemorySaver.
config = {"configurable": {"thread_id": 12345}}


def run_query(input_text: str, echo: bool = False) -> None:
    """Helper function to run queries and print responses

    Args:
        input_text (str): The text to send to the model
        echo (bool): Whether to print the input and output messages
    """
    input_message = input_text
    # By passing stream_mode="values", we get a generator that yields not
    # individual words/characters, but whole messages. These will include not
    # only the human and assistant messages, but also tool-related messages.
    for event in app.stream(
        {"messages": [input_message]}, config, stream_mode="values"
    ):
        if echo:
            event["messages"][-1].pretty_print()
    return event["messages"][-1].content


# Initial weather query. Since we're echoing, we don't need to print the response.
_ = run_query("What's the weather like in Seattle?", echo=True)

print("\n-----------\n")
question = "Can you tell me again what city we were discussing?"
print("Q: " + question)
# Follow-up query to test memory. Since we're not echoing, we print the response.
print("A: " + run_query(question, echo=False))
