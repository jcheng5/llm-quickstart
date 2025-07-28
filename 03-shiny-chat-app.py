# To run this app, execute `shiny run 03-shiny-chat-app.py` at the terminal,
# or in Positron/VS Code with the Shiny extension, use the Run button-menu's
# "Run Shiny App" option.

from chatlas import ChatAnthropic
from dotenv import load_dotenv
from shiny.express import input, ui

_ = load_dotenv()

chat_session = ChatOpenAI(
    model="gpt-4.1",
    system_prompt="You're a trickster who answers in riddles",
)

chat = ui.Chat(id="chat")

chat.ui()


@chat.on_user_submit
async def handle_input():
    user_input = input.chat_user_input()
    response = await chat_session.stream_async(user_input)
    await chat.append_message_stream(response)
