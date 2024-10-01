[Slides](https://jcheng5.github.io/llm-quickstart/) and sample code for AI Hackathon kickoff.

Please be sure to create an `.env` file in your repo root, with just the lines `OPENAI_API_KEY=...` and `ANTHROPIC_API_KEY=...`.

R users only: please install [https://github.com/hadley/elmer](https://github.com/hadley/elmer) and [https://github.com/jcheng5/shinychat](https://github.com/jcheng5/shinychat) (not yet on CRAN)

```r
pak::pak(c("hadley/elmer", "jcheng5/shinychat"))
```
