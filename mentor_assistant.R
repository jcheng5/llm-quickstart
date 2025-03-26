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
      sidebar = sidebar(""),
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
         
         sliderInput("tone", "Select Emotional Tone (gentle, neutral, firm):", 
                     min = 1, max = 3, value = 1, step = 1),
         
         actionButton("generate", "Generate Response")
      ),
      
      mainPanel(
         h3("Generated Mentor Response:"),
         verbatimTextOutput("response")
      )
   )
)
shinyApp(ui, function(...){})


# Function to generate mentor responses based on learner personality and emotional tone
generate_mentor_response <- function(code, personality, tone) {
   
   # Define personalized tone instructions based on learner personality
   personality_prompt <- switch(personality,
                                "Eager" = "The learner is eager and excited to learn. Provide a friendly, encouraging response with a small hint to keep them motivated.",
                                "Resistant" = "The learner seems frustrated or resistant. Keep the tone neutral, professional, and firm. Provide a clear hint without pushing too much.",
                                "Perfectionist" = "The learner has high standards and expects flawless code. Acknowledge their attention to detail, provide a gentle hint, and encourage a balance between perfectionism and moving forward.",
                                "Disengaged" = "The learner seems disengaged or overwhelmed. Keep the tone light, non-judgmental, and encouraging. Break down the issue into simpler steps.")
   
   # Adjust the emotional tone of the response based on the slider
   tone_prompt <- switch(as.character(tone),
                         "1" = "Keep the response gentle, empathetic, and supportive.",
                         "2" = "Keep the response neutral and professional.",
                         "3" = "Make the response firm and authoritative, but still respectful.")
   
   # Combine personality prompt, emotional tone, and debugging request
   prompt <- paste(
      "You are a mentor at Posit Academy. Your job is to help learners debug R code while following these principles:\n",
      "- Acknowledge their effort and issue.\n",
      "- Guide them with a hint instead of giving the full answer.\n",
      "- Provide a partial fix, but encourage them to figure out the final step.\n",
      "- Optionally, explain why the error happened in simple terms.\n\n",
      personality_prompt, "\n",
      tone_prompt, "\n",
      "Here is the learner's code:\n", code, 
      "\nGenerate a response following these principles."
   )
   return(response)
}


