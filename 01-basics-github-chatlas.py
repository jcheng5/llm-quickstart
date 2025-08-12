import os

from chatlas import ChatGithub
from dotenv import load_dotenv

load_dotenv()

chat = ChatGithub(
    model="gpt-4.1",
    system_prompt="You are a terse assistant.",
    api_key=os.getenv("GITHUB_PAT"),
)

chat.chat("What is the capital of the moon?")
chat.chat("Are you sure?")
