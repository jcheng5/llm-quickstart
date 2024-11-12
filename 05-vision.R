library(elmer)

chat <- elmer::chat_openai(model = "gpt-4o")

chat$chat(
  "What photographic choices were made here, and why do you think the photographer chose them?",
  content_image_file("photo.jpg")
)

chat$chat("Come up with an artsy, pretentious, minimalistic, abstract title for this photo.")
