import itertools

from shiny import App, reactive, render, req, ui
from dotenv import load_dotenv

from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_core.chat_history import InMemoryChatMessageHistory
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder

model = ChatOpenAI(model="gpt-4o")

prompt = ChatPromptTemplate.from_messages(
    [
        SystemMessage("You are a terse assistant."),
        MessagesPlaceholder(variable_name="messages"),
    ]
)


app_ui = ui.page_fixed(
    ui.input_text(
        "url",
        "Image URL",
        value="https://live.staticflickr.com/65535/54018015901_1172e43ed6_k.jpg",
    ),
    ui.input_action_button("go", "Start"),
    ui.output_ui("chat_container"),
)


def server(input, output, session):
    chat = ui.Chat("chat")

    @reactive.effect
    @reactive.event(input.go)
    async def start_chat():
        # Start a new conversation
        history = InMemoryChatMessageHistory()
        client = RunnableWithMessageHistory(prompt | model, lambda: history)

        user_prompt = HumanMessage(
            content=[
                {
                    "type": "text",
                    "text": "What tags/keywords would you use to describe this image?",
                },
                {"type": "image_url", "image_url": {"url": input.url()}},
            ]
        )

        stream = client.astream(user_prompt)

        def do_something_with_chunk(chunk):
            print(chunk)
            return chunk.content

        stream2 = (do_something_with_chunk(chunk) async for chunk in stream)

        await chat.append_message_stream(stream2)

        # Allow the user to ask follow up questions
        @chat.on_user_submit
        async def _():
            user_message = HumanMessage(content=chat.user_input())
            stream = client.astream(user_message)

            await chat.append_message_stream(stream)

    @render.ui
    @reactive.event(input.go)
    def chat_container():
        return [ui.img(src=input.url(), style="max-width: 100%"), chat.ui()]


app = App(app_ui, server)
