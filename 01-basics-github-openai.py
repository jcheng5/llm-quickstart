import os

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

# arguments passed switch to using GitHub models
client = OpenAI(
  api_key=os.environ["GITHUB_TOKEN"],
  base_url="https://models.inference.ai.azure.com"
)

messages = [
    {"role": "system", "content": "You are a terse assistant."},
    {"role": "user", "content": "What is the capital of the moon?"},
]

response = client.chat.completions.create(
    model="gpt-4.1",
    messages=messages,
)
print(response.choices[0].message.content)

messages.append(response.choices[0].message)

messages.append({"role": "user", "content": "Are you sure?"})
response2 = client.chat.completions.create(
    model="gpt-4.1",
    messages=messages,
    stream=True,
)

for chunk in response2:
    print(chunk.choices[0].delta.content or "", end="", flush=True)
print()
