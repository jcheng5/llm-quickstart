library(dotenv) # Will read OPENAI_API_KEY from .env file
library(ellmer)
library(shiny)
library(shinychat)

ui <- fluidPage(
   titlePanel("Posit Academy Mentor Response Standardizer"),
   
   sidebarLayout(
      sidebarPanel(
         textAreaInput("code", "Enter Learner's Code or Question:", 
                       placeholder = "Paste the learner's code here...", 
                       rows = 5),
         
         selectInput("personality", "Select Learner Personality:", 
                     choices = c("Eager", "Resistant", "Perfectionist", "Disengaged")),
         
         actionButton("generate", "Generate Response")
      ),
      
      mainPanel(
         h3("Generated Mentor Response:"),
         verbatimTextOutput("response")
      )
   )
)

# Run the app
shinyApp(ui, function(...) {})

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