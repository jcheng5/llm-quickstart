import requests
from dotenv import load_dotenv
from langchain.agents import AgentExecutor, create_openai_tools_agent
from langchain.memory import ConversationBufferMemory
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.tools import tool
from langchain_openai import ChatOpenAI


@tool
def get_weather(latitude, longitude) -> str:
    """Get the current weather for a location using latitude and longitude"""
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


# Initialize the language model
model = ChatOpenAI(model="gpt-4o")

# Create the agent
agent = create_openai_tools_agent(
    llm=model,
    tools=[get_weather],
    prompt=ChatPromptTemplate.from_messages(
        [
            (
                "system",
                "You are a helpful assistant that can check the weather. Report results in imperial units.",
            ),
            MessagesPlaceholder(variable_name="chat_history"),
            ("human", "{input}"),
            MessagesPlaceholder(variable_name="agent_scratchpad"),
        ]
    ),
)

# Create memory
memory = ConversationBufferMemory(memory_key="chat_history", return_messages=True)

# Create an agent executor
agent_executor = AgentExecutor(agent=agent, tools=[get_weather], memory=memory)

# Run the agent
result = agent_executor.invoke({"input": "What's the weather like in Seattle?"})

print(result["output"])
