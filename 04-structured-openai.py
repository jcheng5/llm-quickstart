import json

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

client = OpenAI()

# Create a JSON schema for an object that contains a `fruit` field; that field
# is a list of objects that each have `name` and `color` fields.
schema = {
    "type": "object",
    "properties": {
        "fruit": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "name": {"type": "string"},
                    "color": {"type": "string"},
                },
                "additionalProperties": False,
                "required": ["name", "color"],
            },
        },
    },
    "additionalProperties": False,
    "required": ["fruit"],
}


def get_structured_response(prompt):
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {
                "role": "system",
                "content": "You are a helpful assistant. Always respond in valid JSON format.",
            },
            {"role": "user", "content": prompt},
        ],
        temperature=0.7,
        response_format={
            "type": "json_schema",
            "json_schema": {
                "name": "fruits",
                "schema": schema,
                "strict": True,
            },
        },
    )

    # Parse the response content as JSON
    return json.loads(response.choices[0].message.content)


# Example usage
result = get_structured_response("Give me a list of 3 fruits with their colors")
print(result)
