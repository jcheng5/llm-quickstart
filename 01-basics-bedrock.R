library(ellmer)

chat <- chat_bedrock(
  model = "us.anthropic.claude-3-5-sonnet-20241022-v2:0",
  system_prompt = "You are a terse assistant.",
)
chat$chat("What is the capital of the moon?")

# The `chat` object is stateful, so this continues the existing conversation
chat$chat("Are you sure about that?")
