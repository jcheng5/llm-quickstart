library(shiny)
library(shinychat)
library(ellmer)

dotenv::load_dot_env("../../.env")

# Load the system prompt from disk
system_prompt <- paste(collapse = "\n", readLines("prompt.md", warn = FALSE))

ui <- bslib::page_fluid(
  chat_ui("chat")
)

server <- function(input, output, session) {
  chat <- ellmer::chat_openai(
    model = "gpt-4.1",
    system_prompt = system_prompt
  )

  chat$register_tool(tool(
    convert_length,
    "Converts a length from one unit to another.",
    value = type_number(
      "The numerical value of the length to be converted."
    ),
    from_unit = type_string(
      "input unit (meters, kilometers, miles, feet, inches, centimeters)."
    ),
    to_unit = type_string(
      "output unit (meters, kilometers, miles, feet, inches, centimeters)."
    )
  ))

  chat$register_tool(tool(
    convert_mass,
    "Converts a mass from one unit to another.",
    value = type_number(
      "The numerical value of the mass to be converted."
    ),
    from_unit = type_string(
      "input unit (grams, kilograms, pounds, ounces)."
    ),
    to_unit = type_string(
      "output unit (grams, kilograms, pounds, ounces)."
    )
  ))

  chat$register_tool(tool(
    add,
    "Calculates the sum of two numbers.",
    x = type_number(
      "The first number to be added."
    ),
    y = type_number(
      "The second number to be added."
    )
  ))

  chat$register_tool(tool(
    multiply,
    "Calculates the product of two numbers.",
    x = type_number(
      "The first number to be multiplied."
    ),
    y = type_number(
      "The second number to be multiplied."
    )
  ))


  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
  chat_append("chat", "Hi, I'm **Unit Coversion Assistant**! I can do unit conversions and simple calculations for you.")
}


# ==============================================================================
# Unit conversion functions
# ==============================================================================

#' Convert length units
#'
#' This function converts a value from one length unit to another.
#'
#' @param value Numeric value to be converted
#' @param from_unit Character string specifying the unit to convert from
#' @param to_unit Character string specifying the unit to convert to
#' @return Numeric value after conversion
#' @details Allowable units: meters, kilometers, miles, feet, inches
#' @examples
#' convert_length(5, "meters", "feet")
#' convert_length(10, "kilometers", "miles")
convert_length <- function(value, from_unit, to_unit) {
  cat(paste0("Called convert_length(", value, ', "', from_unit, '", "', to_unit, '")\n'))
  units <- c(
    meters = 1,
    kilometers = 1e3,
    miles = 1609.344,
    feet = 0.3048,
    inches = 0.0254,
    centimeters = 0.01
  )

  from_unit <- tolower(from_unit)
  to_unit <- tolower(to_unit)

  if (!(from_unit %in% names(units))) {
    stop(paste("Invalid 'from' unit:", from_unit))
  }
  if (!(to_unit %in% names(units))) {
    stop(paste("Invalid 'to' unit:", to_unit))
  }

  value_in_meters <- value * units[from_unit]
  converted_value <- value_in_meters / units[to_unit]
  converted_value
}


#' Convert mass units
#'
#' This function converts a value from one mass unit to another.
#'
#' @param value Numeric value to be converted
#' @param from_unit Character string specifying the unit to convert from
#' @param to_unit Character string specifying the unit to convert to
#' @return Numeric value after conversion
#' @details Allowable units: grams, kilograms, pounds, ounces
#' @examples
#' convert_mass(1000, "grams", "kilograms")
#' convert_mass(5, "pounds", "ounces")
convert_mass <- function(value, from_unit, to_unit) {
  cat(paste0("Called convert_mass(", value, ', "', from_unit, '", "', to_unit, '")\n'))
  units <- c(
    grams = 0.001,
    kilograms = 1,
    pounds = 0.45359237,
    ounces = 0.02834952
  )

  from_unit <- tolower(from_unit)
  to_unit <- tolower(to_unit)

  if (!(from_unit %in% names(units))) {
    stop(paste("Invalid 'from' unit:", from_unit))
  }
  if (!(to_unit %in% names(units))) {
    stop(paste("Invalid 'to' unit:", to_unit))
  }

  value_in_kg <- value * units[from_unit]
  converted_value <- value_in_kg / units[to_unit]
  converted_value
}

add <- function(x, y) {
  cat(paste0("Called add(", x, ", ", y, ")\n"))
  x + y
}

multiply <- function(x, y) {
  cat(paste0("Called multiply(", x, ", ", y, ")\n"))
  x * y
}



shinyApp(ui, server)
