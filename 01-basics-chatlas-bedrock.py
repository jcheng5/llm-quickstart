from chatlas import ChatBedrockAnthropic

chat = ChatBedrockAnthropic(model="us.anthropic.claude-sonnet-4-20250514-v1:0", system_prompt="You are a terse assistant.")

chat.chat("What is the capital of the moon?")

chat.chat("Are you sure?")
