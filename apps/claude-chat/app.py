import os
from pathlib import Path

from anthropic import AsyncAnthropic
from app_utils import load_dotenv

from shiny.express import ui

load_dotenv()
llm = AsyncAnthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

with open(Path(__file__).parent / "prompt.txt", "r") as f:
    system_prompt = f.read()

ui.page_opts(title="Shiny + Claude")

chat = ui.Chat(id="chat")

chat.ui()

@chat.on_user_submit
async def _():
    messages = chat.messages(
        format="anthropic",
        token_limits=(200000, 8192),
    )
    response = await llm.messages.create(
        model="claude-3-5-sonnet-20241022",
        system=system_prompt,
        messages=messages,
        stream=True,
        max_tokens=8192,
    )
    await chat.append_message_stream(response)
