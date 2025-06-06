library(dotenv) # Will read OPENAI_API_KEY from .env file
library(ellmer)

chat <- chat_openai(
  model = "gpt-4.1",
  system_prompt = "You are a terse assistant.",
)
chat$chat("What is the capital of the moon?")

# The `chat` object is stateful, so this continues the existing conversation
chat$chat("Are you sure about that?")
