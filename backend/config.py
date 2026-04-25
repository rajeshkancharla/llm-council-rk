"""Configuration for the LLM Council."""

import os
from dotenv import load_dotenv

load_dotenv()

# OpenRouter API key
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

# Council members - list of OpenRouter model identifiers
# Use a simpler model set that is more likely to be available
# on a standard OpenRouter account with purchased credits.
COUNCIL_MODELS = [
    "openai/gpt-4o"
]

# Chairman model - synthesizes final response
CHAIRMAN_MODEL = "openai/gpt-4o"

# OpenRouter API endpoint
OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions"

# Data directory for conversation storage
DATA_DIR = "data/conversations"
