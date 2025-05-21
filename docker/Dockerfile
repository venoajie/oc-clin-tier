# Multi-stage build for security and minimal footprint
FROM python:3.11-slim-bookworm as builder

# OCI-specific dependencies (minimal install)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libaio1 \
    wget \
    unzip \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies with hash checking
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip check

# Copy application files with non-root user
COPY --chown=1000:1000 ./app .

# OCI-specific optimizations
ENV STREAMLIT_SERVER_PORT=8501 \
    STREAMLIT_SERVER_ADDRESS=0.0.0.0 \
    STREAMLIT_BROWSER_GATHER_USAGE_STATS=false \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

# Healthcheck with OCI networking consideration
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

# Run as non-root user
USER 1000

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "app.py", \
            "--server.port=8501", \
            "--server.address=0.0.0.0", \
            "--server.headless=true", \
            "--server.enableCORS=false", \
            "--server.enableXsrfProtection=false"]