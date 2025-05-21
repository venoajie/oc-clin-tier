FROM python:3.11-slim-bookworm

# 1. Create dedicated user and directories
RUN adduser --disabled-password --gecos "" appuser && \
    mkdir -p /app/cache/litellm /app/data && \
    chown -R appuser:appuser /app && \
    chmod -R 770 /app

WORKDIR /app

# 2. Install system dependencies + Oracle Instant Client
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools \
    wget \
    unzip \
    libaio1 && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /usr/lib && \
    rm /tmp/instantclient.zip && \
    echo /usr/lib/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    rm -rf /var/lib/apt/lists/*

# 3. Install Python requirements
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip cache purge

# 4. Force LiteLLM to use writable directory
RUN mkdir -p /app/cache/litellm && \
    chown -R appuser:appuser /app/cache/litellm && \
    ln -sf /app/cache/litellm /usr/local/lib/python3.11/site-packages/litellm/tokenizers

# 5. Copy application files
COPY --chown=appuser:appuser ./app .

# 6. Environment configuration
ENV XDG_CACHE_HOME=/app/cache \
    LITELLM_CACHE_DIR=/app/cache/litellm \
    LD_LIBRARY_PATH=/usr/lib/instantclient_21_1:$LD_LIBRARY_PATH \
    TMPDIR=/app/cache/tmp

USER appuser

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]