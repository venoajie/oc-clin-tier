FROM python:3.11-slim-bookworm

# 1. Create app user and directories with elevated permissions
RUN adduser --disabled-password --gecos "" appuser && \
    mkdir -p /app/cache/litellm/tokenizers && \
    chown -R appuser:appuser /app && \
    chmod -R 777 /app  # Temporary wide permissions

# 2. Force LiteLLM to use our cache directory before installation
RUN mkdir -p /usr/local/lib/python3.11/site-packages/litellm/litellm_core_utils && \
    ln -s /app/cache/litellm/tokenizers /usr/local/lib/python3.11/site-packages/litellm/litellm_core_utils/tokenizers && \
    chown -R appuser:appuser /usr/local/lib/python3.11/site-packages/litellm

WORKDIR /app

# 3. Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools && \
    rm -rf /var/lib/apt/lists/*

# 4. Install Python requirements
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 5. Copy application files
COPY --chown=appuser:appuser ./app .

# 6. Environment configuration
ENV LITELLM_CACHE_DIR=/app/cache/litellm \
    XDG_CACHE_HOME=/app/cache \
    TMPDIR=/app/cache/tmp

USER appuser

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]