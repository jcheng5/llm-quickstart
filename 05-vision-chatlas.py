from chatlas import ChatOpenAI, content_image_file
from dotenv import load_dotenv

load_dotenv()  # Loads OPENAI_API_KEY from the .env file

chat = ChatOpenAI(model="gpt-4o")

print(chat.chat(
    content_image_file("photo.jpg"),
    "What photographic choices were made here, and why do you think the photographer chose them?"
))

print(chat.chat("Come up with an artsy, pretentious, minimalistic, abstract title for this photo."))