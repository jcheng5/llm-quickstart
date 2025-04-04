# Creating an assistant that will help mentors craft messages for learners
# with some level of customization to match learner engagement

# created by javirudolph
# with significant help from ellmer assistant

library(dotenv) # Will read OPENAI_API_KEY from .env file

library(shiny)
library(shinychat)
library(bslib)
library(ellmer)

ui <- bslib::page_fluid(
   titlePanel("Code debug message assistant"),
   
   # Apply custom theme
   theme = bs_theme(bootswatch = "journal"),
   
   sidebarLayout(
      sidebarPanel(
         selectInput("personality", "Learner Personality:",
                     choices = c("Eager", "Resistant", "Perfectionist", "Disengaged")),
         sliderInput("tone", "Response Tone:", min = 1, max = 10, value = 5,
                     post = " Gentle -- Firm"),
         sliderInput("frustration", "Learner Frustration Level:", min = 1, max = 10, value = 3,
                     post = " Low -- High"),
         textAreaInput("learner_code", "Learner Code to Debug:", "", rows = 8),
         actionButton("generate_prompt", "Generate Prompt")
      ),
      mainPanel(
         chat_ui("chat")
      )
   )
)


# Function to generate mentor responses based on learner personality and emotional tone
generate_mentor_response <- function(code, personality, tone, frustration) {
   
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
   
   # Include the learner's frustration level
   frustration_prompt <- paste("The learner is experiencing a frustration level of: ", "where 1 is the lowest and 10 is the highest")
   
   # Combine personality prompt, emotional tone, and debugging request
   prompt <- paste(
      "You are a mentor at Posit Academy. Your job is to help learners debug R code while following these principles:\n",
      "- Acknowledge their effort and issue.\n",
      "- Guide them with a hint instead of giving the full answer.\n",
      "- Provide a partial fix, but encourage them to figure out the final step.\n",
      "- Optionally, explain why the error happened in simple terms.\n\n",
      "- Keep it as short as possible",
      personality_prompt, "\n",
      tone_prompt, "\n",
      frustration_prompt, "\n",
      "Here is the learner's code:\n", "`", code, "`", 
      "\nGenerate a response following these principles."
   )
   return(prompt)
}


server <- function(input, output, session) {
   
   chat <- ellmer::chat_openai(
      model = "gpt-4o-mini", 
      system_prompt = "You are a friendly assistant."
   )
   
   # Generate the prompt from user input and send it to LLM
   observeEvent(input$generate_prompt, {
      prompt <- generate_mentor_response(input$learner_code,
                                         input$personality,
                                         input$tone,
                                         input$frustration)
      # Use chat to process the prompt
      stream <- chat$stream_async(prompt)
      chat_append("chat", stream)      
   })

   observeEvent(input$chat_user_input, {
      stream <- chat$stream_async(input$chat_user_input)
      chat_append("chat", stream)
   })   
}

shinyApp(ui, server)

# To thest in the code box
# ggplot(mtcars) + geom_point()
