Example Shiny chat apps
=======================

This project contains three Shiny chat applications:
- `basic-chat` provides a chat interface to an LLM from OpenAI, similar to the one available at [chatgpt.com](https://chatgpt.com/).
- `rag-chat` provides an example of Retrieval-Augmented Generation, where the chat application queries documentation from quarto.org Quarto to look for relevant pieces of information, then passes that information to an LLM, and asks the LLM to answer the user query using that information.
- `claude-chat` provides a chat interface for Claude 3.5 Sonnet, similar to the one available at [claude.ai](https://claude.ai/). This has both R and Python versions.

To run these apps, first install some packages from R:

```R
if (!require("pak")) install.packages("pak")  # Instal pak if not already installed
pak::pak(c("dotenv", "shiny", "tidyverse/elmer", "jcheng5/shinychat"))
```

Then create a file named `.env` in the project directory with API keys that you have been provided. (Replace the `XXXXXXXX` below with the actual API keys.)

```
OPENAI_API_KEY="XXXXXXX"
ANTHROPIC_API_KEY="XXXXXXX"
EMBEDDING_IO_API_KEY="XXXXXXXX"
```

Next, open `basic-chat/app.R` in the editor and click on the Run button. You should now have a running chat application!

For the RAG app, open `rag-chat/app.R` and click on the Run button.
