library(shiny)
library(shinychat)
library(bslib)

dotenv::load_dot_env("../../.env")

prompt <- paste(collapse = "\n", readLines("prompt.txt", warn = FALSE))

ui <- page_fluid(
  h2(class = "text-center pt-4", "Shiny + Claude"),
  chat_ui("chat")
)

server <- function(input, output, session) {
  chat <- elmer::chat_claude(
    model = "claude-3-5-sonnet-20241022",
    system_prompt = prompt
  )
  observeEvent(input$chat_user_input, {
    chat_append("chat", chat$stream_async(input$chat_user_input))
  })
}

shinyApp(ui, server)
