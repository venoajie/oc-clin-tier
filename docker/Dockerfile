FROM python:3.11-slim-bookworm

# 1. Install system dependencies including wget
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools \
    wget && \
    rm -rf /var/lib/apt/lists/*

# 2. Create directory structure
RUN mkdir -p /app/cache/litellm/tokenizers && \
    mkdir -p /usr/local/lib/python3.11/site-packages/litellm/litellm_core_utils && \
    chmod -R 777 /app

WORKDIR /app

# 3. Install Python requirements
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 4. Download and place tokenizer files
RUN wget https://raw.githubusercontent.com/BerriAI/litellm/main/litellm/tokenizers/anthropic_tokenizer.json -P /app/cache/litellm/tokenizers/ && \
    wget https://raw.githubusercontent.com/BerriAI/litellm/main/litellm/tokenizers/cohere_tokenizer.json -P /app/cache/litellm/tokenizers/ && \
    ln -sf /app/cache/litellm/tokenizers /usr/local/lib/python3.11/site-packages/litellm/litellm_core_utils/tokenizers

# 5. Create dedicated user
RUN adduser --disabled-password --gecos "" appuser && \
    chown -R appuser:appuser /app

# 6. Copy application files
COPY --chown=appuser:appuser ./app .

# 7. Environment configuration
ENV LITELLM_CACHE_DIR=/app/cache/litellm \
    XDG_CACHE_HOME=/app/cache \
    TMPDIR=/app/cache/tmp

USER appuser

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]