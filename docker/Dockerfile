FROM python:3.11-slim-bookworm

# 1. Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools \
    wget && \
    rm -rf /var/lib/apt/lists/*

# 2. Create directory structure
RUN mkdir -p /app/cache/litellm/tokenizers && \
    chmod -R 777 /app

WORKDIR /app

# 3. Install Python requirements with pinned versions
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --force-reinstall "litellm>=1.0.0"

# 4. Download missing tokenizer files
RUN wget https://raw.githubusercontent.com/BerriAI/litellm/main/litellm/tokenizers/anthropic_tokenizer.json -P /usr/local/lib/python3.11/site-packages/litellm/tokenizers/ && \
    wget https://raw.githubusercontent.com/BerriAI/litellm/main/litellm/tokenizers/cohere_tokenizer.json -P /usr/local/lib/python3.11/site-packages/litellm/tokenizers/

# 5. Setup cache symlinks
RUN ln -sf /app/cache/litellm/tokenizers /usr/local/lib/python3.11/site-packages/litellm/litellm_core_utils/tokenizers && \
    chmod -R 777 /app/cache

# 6. Create non-root user
RUN adduser --disabled-password --gecos "" appuser && \
    chown -R appuser:appuser /app

COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]