library(dotenv)
library(ellmer)

chat <- chat_github(
  model = "gpt-4.1",
  system_prompt = "You are a terse assistant.",
)
chat$chat("What is the capital of the moon?")
chat$chat("Are you sure about that?")
