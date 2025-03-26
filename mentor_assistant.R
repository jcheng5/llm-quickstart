library(dotenv) # Will read OPENAI_API_KEY from .env file
library(ellmer)
library(shiny)
library(shinychat)
library(bslib)

my_theme <- bs_theme(bootswatch = "cerulean")

ui <- bslib::page_fluid(
   h1("Posit Academy Mentor Assistant"),
   theme = my_theme,
   layout_sidebar(
      sidebar = sidebar("Sidebar"),
      chat_ui("chat")
   )
)
shinyApp(ui, function(...){})

empathetic_learner_promt <- "You are the assistant for a mentor at Posit Academy. 
    Your job is to help mentors craft empathetic responses for learners to debug R code while following these guidelines:
        1. Acknowledge the learners effort and the issue they are having.
        2. Guide them with a hint instead of giving the full answer.
        3. Provide a partial fix, but encourage them to figure out the final step.
        4. Optionally, explain why the error happened in simple terms.
        5. make it short"

server <- function(input, output, session) {
   chat <- ellmer::chat_openai(system_prompt = empathetic_learner_promt)
   
   observeEvent(input$chat_user_input, {
      stream <- chat$stream_async(input$chat_user_input)
      chat_append("chat", stream)
   })
}

shinyApp(ui, server)


# I want this ui but I can't figure out how to get that into the new package for formatting
ui <- fluidPage(
   titlePanel("Posit Academy Mentor Response Standardizer"),
   
   sidebarLayout(
      sidebarPanel(
         textAreaInput("code", "Enter Learner's Code or Question:", 
                       placeholder = "Paste the learner's code here...", 
                       rows = 5),
         
         selectInput("personality", "Select Learner Personality:", 
                     choices = c("Eager", "Resistant", "Perfectionist", "Disengaged")),
         
         sliderInput("tone", "Select Emotional Tone (learner frustration level):", 
                     min = 1, max = 10, value = 1, step = 1),
         
         actionButton("generate", "Generate Response")
      ),
      
      mainPanel(
         h3("Generated Mentor Response:"),
         verbatimTextOutput("response")
      )
   )
)
shinyApp(ui, function(...){})

