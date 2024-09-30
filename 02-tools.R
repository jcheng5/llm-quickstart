library(dotenv) # Will read OPENAI_API_KEY from .env file
library(elmer)
library(beepr)

#' Plays a sound effect.
#'
#' @param sound Which sound effect to play.
#' @returns NULL
play_sound <- function(sound = c("correct", "incorrect", "you-win")) {
  sound <- match.arg(sound)
  if (sound == "correct") {
    beepr::beep("coin")
  } else if (sound == "incorrect") {
    beepr::beep("wilhelm")
  } else if (sound == "you-win") {
    beepr::beep("fanfare")
  }
  NULL
}

chat <- new_chat_openai(
  model = "gpt-4",
  system_prompt = paste(
    "You're hosting a quiz game show.

    * Before you start, ask the user to choose a theme.
    * Ask simple questions and ask the user to answer them via multiple choice.
    * After the user answers, provide feedback and then move on to the next question.
    * After every 5 questions, declare the user to be a winner regardless of their score, lavish them with praise, and start the game over.
    * Play sound effects for each answer, and when the user 'wins'.
    * Emojis are fun, use them liberally!"
  ),
  echo = TRUE # Should chat responses be logged to stdout?
)

# Give the chatbot the ability to play a sound.
#
# Created using `elmer::create_tool_metadata(play_sound)`
chat$register_tool(
  fun = play_sound,
  name = "play_sound",
  description = "Plays a sound effect.",
  arguments = list(
    sound = tool_arg(
      type = "string",
      description = "Which sound effect to play. Options are 'correct', 'incorrect', 'you-win'. Defaults to 'correct'.",
      required = FALSE
    )
  )
)

chat$chat("Begin", echo = TRUE) # Jump-start the conversation
chat_console(chat, quiet = TRUE) # Continue the conversation
