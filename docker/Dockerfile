FROM python:3.11-slim-bookworm

# 1. Create dedicated user and directories
RUN adduser --disabled-password --gecos "" appuser && \
    mkdir -p /app/cache/litellm /app/data && \
    chown -R appuser:appuser /app && \
    chmod -R 770 /app  # More permissive for cache

WORKDIR /app

# 2. Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools \
    && rm -rf /var/lib/apt/lists/*

# 3. Install Python requirements
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip cache purge

# 4. Force LiteLLM to use our cache directory
RUN mkdir -p /usr/local/lib/python3.11/site-packages/litellm/litellm_core_utils/tokenizers && \
    chown -R appuser:appuser /usr/local/lib/python3.11/site-packages/litellm && \
    chmod -R 777 /usr/local/lib/python3.11/site-packages/litellm  # Security note: Temporary measure

# 5. Copy application files
COPY --chown=appuser:appuser ./app .

# 6. Environment configuration
ENV XDG_CACHE_HOME=/app/cache \
    LITELLM_CACHE_DIR=/app/cache/litellm \
    LYZR_CACHE_DIR=/app/cache/lyzr \
    TRANSFORMERS_CACHE=/app/cache \
    HF_HOME=/app/cache \
    TMPDIR=/app/cache/tmp \
    PIP_NO_CACHE_DIR=on

USER appuser

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0", \
     "--global.developmentMode=false"]