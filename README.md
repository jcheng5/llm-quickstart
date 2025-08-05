[Slides](https://jcheng5.github.io/llm-quickstart/) and sample code for AI Hackathon kickoff.

Please be sure to create an `.env` file in your repo root, with just the lines `OPENAI_API_KEY=...` and `ANTHROPIC_API_KEY=...`.

## If you plan to use R

```r
install.packages(c("ellmer", "shinychat", "dotenv", "shiny"))
```

## If you plan to use Python

Please create and activate a virtualenv (or conda env), then:

```
pip install -r requirements.txt
```

Or if using uv, you can instead run:

```
uv sync
```

## If you plan to use Go

You can try the [official (alpha) OpenAI client](https://github.com/openai/openai-go) or [this unofficial but popular one](https://github.com/sashabaranov/go-openai).