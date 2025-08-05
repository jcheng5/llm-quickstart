library(ellmer)

chat <- chat_aws_bedrock(
  model = "us.anthropic.claude-sonnet-4-20250514-v1:0",
  system_prompt = "You are a terse assistant.",
)
chat$chat("What is the capital of the moon?")

# The `chat` object is stateful, so this continues the existing conversation
chat$chat("Are you sure about that?")
