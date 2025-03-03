from chatlas import ChatBedrockAnthropic

chat = ChatBedrockAnthropic(model="us.anthropic.claude-3-5-sonnet-20241022-v2:0", system_prompt="You are a terse assistant.")

chat.chat("What is the capital of the moon?")

chat.chat("Are you sure?")
