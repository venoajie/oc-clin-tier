FROM python:3.11-slim-bookworm

# 1. Create dedicated user and directories
RUN adduser --disabled-password --gecos "" appuser && \
    mkdir -p /app/cache /app/data && \
    chown -R appuser:appuser /app && \
    chmod -R 750 /app  # More secure than 755

WORKDIR /app

# 2. Install system dependencies first (better layer caching)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools \
    && rm -rf /var/lib/apt/lists/*

# 3. Install Python requirements with cache control
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip cache purge

# 4. Copy application files with correct ownership
COPY --chown=appuser:appuser ./app .

# 5. Comprehensive cache/temp configuration
ENV XDG_CACHE_HOME=/app/cache \
    LITELLM_CACHE_DIR=/app/cache \
    LYZR_CACHE_DIR=/app/cache/lyzr \
    TRANSFORMERS_CACHE=/app/cache \
    HF_HOME=/app/cache \
    TMPDIR=/app/cache/tmp \
    PIP_NO_CACHE_DIR=on

# Create temp subdirectory
RUN mkdir -p /app/cache/tmp && \
    chown appuser:appuser /app/cache/tmp && \
    chmod 770 /app/cache/tmp

USER appuser

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0", \
     "--global.developmentMode=false"]  # Important for production