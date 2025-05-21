FROM python:3.11-slim-bullseye


# Install only essential dependencies (no Oracle)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnss3-tools \
    rm -rf /var/lib/apt/lists/*  

# Create cache directory with correct permissions
RUN mkdir -p /app/cache && \
    chown -R 1000:1000 /app && \
    chmod -R 755 /app

WORKDIR /app

# Copy requirements first for caching

# Copy requirements first for caching
COPY ./app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
    
# Copy the entire app directory
COPY ./app .

# Set environment variables for temp files
ENV XDG_CACHE_HOME=/app/cache \
    LITELLM_CACHE_DIR=/app/cache \
    PIP_NO_CACHE_DIR=off

ENV LYZR_CACHE_DIR=/app/cache/lyzr

USER 1000

EXPOSE 8501


CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]
     