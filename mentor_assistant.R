library(dotenv) # Will read OPENAI_API_KEY from .env file
library(ellmer)
library(shiny)
library(shinychat)

ui <- bslib::page_fluid(
   chat_ui("chat")
)

ui <- page_fluid(
   h2(class = "text-center pt-4", "Shiny + Claude"),
   chat_ui("chat")
)

server <- function(input, output, session) {
   chat <- chat_openai(
      model = "gpt-4o",
      system_prompt = "You're a trickster who answers in riddles"
   )
   
   observeEvent(input$chat_user_input, {
      stream <- chat$stream_async(input$chat_user_input)
      chat_append("chat", stream)
   })
}

shinyApp(ui, server)