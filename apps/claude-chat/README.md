Shiny + Claude Chat app
=======================

This is a Shiny application which provides a chat interface for Claude Sonnet 4, similar to the one available at [claude.ai](https://claude.ai/).

This application is deployed at https://gallery.shinyapps.io/shiny-claude/.

There is an R version of the application in app.R, and a Python version in app.py.

To run the R version, first install some packages, then run the app:

```R
# install.packages("pak")
pak::pak(c("shiny", "tidyverse/ellmer"))
```


To run the Python version, first install the dependencies, then run the app:

```bash
# Run at the command prompt
pip install -r requirements.txt
shiny run app.py
```


## Notes

Both the R and Python versions of the application read prompt.txt. This is the [Claude system prompt](https://docs.anthropic.com/en/release-notes/system-prompts#sept-9th-2024) published by Anthropic, so the chat bot should behave like Claude.ai.
