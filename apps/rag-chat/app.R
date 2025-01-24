library(shiny)
library(shinychat)
library(httr2)
library(jsonlite)

dotenv::load_dot_env("../../.env")

EMBEDDING_IO_API_KEY <- Sys.getenv("EMBEDDING_IO_API_KEY")
# The ID for the document collection on embedding.io
COLLECTION_ID <- "col_j2mv9wQ1xwXNod"

# Function to send HTTP request and retrieve augmented documents
retrieve_docs <- function(query) {
  req <- request("https://api.embedding.io/v0/query")
  # print(paste0("Bearer ", EMBEDDING_IO_API_KEY))

  req <- req |>
    req_headers(
      "Authorization" = paste0("Bearer ", EMBEDDING_IO_API_KEY)
    ) |>
    req_body_json(
      list(
        "collection" = COLLECTION_ID,
        "query" = query
      )
    )

  req |> req_dry_run()

  response <- req_perform(req)

  # Parse the response as JSON and extract the relevant documents
  content <- resp_body_json(response)

  # The `content` object will contain a list of lists. Each of the inner lists
  # has a structure like this:
  #  $ :List of 5
  #   ..$ page    :List of 10
  #   .. ..$ id         : chr "pag_jWwa7m9AKE7mYP"
  #   .. ..$ url        : chr "https://quarto.org/docs/output-formats/html-lightbox-figures.html"
  #   .. ..$ title      : chr "Lightbox Figures – Quarto"
  #   .. ..$ description: NULL
  #   .. ..$ og_type    : NULL
  #   .. ..$ og_image   : chr "https://quarto.org/docs/output-formats/quarto-dark-bg.jpeg"
  #   .. ..$ h1         : chr "Lightbox Figures"
  #   .. ..$ word_count : int 994
  #   .. ..$ status     : chr "Ready"
  #   .. ..$ crawled_at : chr "2024-10-05T20:38:53+00:00"
  #   ..$ metadata:List of 2
  #   .. ..$ h1: chr "Lightbox Figures"
  #   .. ..$ h2: chr "Galleries"
  #   ..$ content : chr "In addition to simply providing a lightbox treatment..."
  #   ..$ index   : int 6
  #   ..$ score   : num 0.409

  all_item_contents <- lapply(content, function(item) {
    return(item$content)
  })

  retrieved_docs <- paste(all_item_contents, collapse = "\n\n")
  return(retrieved_docs)
}

ui <- bslib::page_fluid(
  h2("Chat about Quarto with RAG"),
  chat_ui("chat")
)

server <- function(input, output, session) {
  chat <- ellmer::chat_openai(
    model = "gpt-4o",
  )

  observeEvent(input$chat_user_input, {
    query <- input$chat_user_input

    # Retrieve context documents from external source
    docs <- retrieve_docs(query)

    # Combine the user input and retrieved documents
    context_query <- paste(
      "Please carefully read the following content. This is documentation about Quarto.",
      "Later, you may be asked a question about Quarto. Use this content to help answer the question.",
      "You may use your other existing knowledge to help answer the question.",

      "<content>",
      paste(docs, collapse = "\n\n"),
      "</content>",
      "<query>",
      query,
      "</query>",
      sep = "\n"
    )

    # Uncomment this to see the query printed to the console.
    # cat(context_query)

    # Send query with context to chat
    stream <- chat$stream_async(context_query)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
