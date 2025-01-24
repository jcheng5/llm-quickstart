# -----------------------------------------------------------
# chatlas is a new package we're working on.
# It's not yet on PyPI, but you can install it from GitHub:
#
# pip install git+https://github.com/cpsievert/chatlas
#
# The README is currently the best place to get an overview
# https://github.com/cpsievert/chatlas#readme
#
# Also, note that chatlas is essentially the Python equivalent of
# https://github.com/tidyverse/ellmer/
# -----------------------------------------------------------

from chatlas import ChatOpenAI
from dotenv import load_dotenv

load_dotenv()  # Loads OPENAI_API_KEY from the .env file

chat = ChatOpenAI(model="gpt-4o", system_prompt="You are a terse assistant.")

chat.chat("What is the capital of the moon?")

chat.chat("Are you sure?")
