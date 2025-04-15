library(shiny)
library(shinychat)

dotenv::load_dot_env("../../.env")

# Load the system prompt from disk
system_prompt <- paste(collapse = "\n", readLines("prompt.md", warn = FALSE))

ui <- bslib::page_fluid(
  h2("Basic chat about R"),
  chat_ui("chat")
)

server <- function(input, output, session) {
  chat <- ellmer::chat_openai(
    model = "gpt-4.1",
    system_prompt = system_prompt
  )

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
