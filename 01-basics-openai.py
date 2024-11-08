from pprint import pprint

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()  # Loads OPENAI_API_KEY from the .env file

# Creates an OpenAI client, which can be used to access any OpenAI service
# (including Whisper and DALL-E, not just chat models). It's totally stateless.
client = OpenAI()

# The initial set of messages we'll start the conversation with: a system
# prompt and a user prompt.
messages = [
    {"role": "system", "content": "You are a terse assistant."},
    {"role": "user", "content": "What is the capital of the moon?"},
]

# Call out to the OpenAI API to generate a response. (This is a blocking call,
# but there are ways to do async, streaming, and async streaming as well.)
response = client.chat.completions.create(
    model="gpt-4o",
    messages=messages,
)

# Print the response we just received.
print(response.choices[0].message.content)
# If you want to inspect the full response, you can do so by uncommenting the
# following line. The .dict() is helpful in getting more readable output.
# pprint(response.dict())

# The client.chat.completions.create() call is stateless. In order to carry on a
# multi-turn conversation, we need to keep track of the messages we've sent and
# received.
messages.append(response.choices[0].message)

# Ask a followup question.
messages.append({"role": "user", "content": "Are you sure?"})
response2 = client.chat.completions.create(
    model="gpt-4o",
    messages=messages,
    stream=True,
)

for chunk in response2:
    print(chunk.choices[0].delta.content or "", end="", flush=True)
print()
