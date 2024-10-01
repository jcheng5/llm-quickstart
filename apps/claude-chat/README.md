Shiny + Claude Chat app
=======================

This is a Shiny application which provides a chat interface for Claude 3.5 Sonnet, similar to the one available at [claude.ai](https://claude.ai/).

This application is deployed at https://gallery.shinyapps.io/shiny-claude/.

Currently only the Python version of the app is available. The R version will work once the elmer package adds support for Anthropic models.

First install the dependencies, then run the app:

```bash
# Run at the command prompt
pip install -r requirements.txt
shiny run app.py
```


## Notes

Both the R and Python versions of the application read prompt.txt. This is the [Claude system prompt](https://docs.anthropic.com/en/release-notes/system-prompts#sept-9th-2024) published by Anthropic, so the chat bot should behave like Claude.ai.
