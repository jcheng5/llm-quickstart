from dotenv import load_dotenv
from langchain_core.chat_history import InMemoryChatMessageHistory
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_openai import ChatOpenAI

load_dotenv()  # Loads OPENAI_API_KEY from the .env file

# Create an OpenAI chat model, with conversation history.
# See https://python.langchain.com/docs/tutorials/chatbot/ for more information.

# The underlying chat model. It doesn't manage any state, so we need to wrap it.
model = ChatOpenAI(model="gpt-4o")

# This is how you provide a system message in Langchain. Surprisingly
# complicated, isn't it?
prompt = ChatPromptTemplate.from_messages(
    [
        SystemMessage("You are a terse assistant."),
        MessagesPlaceholder(variable_name="messages"),
    ]
)

# Wrap the model and prompt up with some history.
history = InMemoryChatMessageHistory()
client = RunnableWithMessageHistory(prompt | model, lambda: history)

# We're ready to chat with the model now. For this example we'll make a blocking
# call, but there are ways to do async, streaming, and async streaming as well.
response = client.invoke("What is the capital of the moon?")
print(response.content)

# The input of invoke() can be a message object as well, or a list of messages.
response2 = client.invoke(HumanMessage("Are you sure?"))
print(response2.content)
