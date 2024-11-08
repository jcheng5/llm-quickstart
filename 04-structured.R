library(dotenv) # Will read OPENAI_API_KEY from .env file
library(elmer)

# Define the structured data specification using elmer's `type_` functions
fruit_schema <- type_object(
  "A list of fruits and their colors.",
  fruit = type_array(
    items = type_object(
      name = type_string("The name of the fruit."),
      color = type_string("The color of the fruit.")
    )
  )
)

# Create a chat object with a specific system prompt
chat <- chat_openai(
  model = "gpt-4o",
  system_prompt = "You are a helpful assistant. Always respond in valid JSON format."
)

# Function to get structured response
get_structured_response <- function(prompt) {
  chat$extract_data(
    prompt,
    spec = fruit_schema
  )
}

# Example usage
result <- get_structured_response("Give me a list of 3 fruits with their colors")
print(jsonlite::toJSON(result, auto_unbox = TRUE, pretty = TRUE))
