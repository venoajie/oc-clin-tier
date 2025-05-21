FROM python:3.11-slim-bullseye

# Install OCI CLI + Instant Client (free)
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /usr/lib && \
    rm /tmp/instantclient.zip && \
    echo /usr/lib/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

RUN    apt-get install -y --no-install-recommends \  
    libnss3-tools && \  
    apt-get clean && \  
    rm -rf /var/lib/apt/lists/*  

WORKDIR /app

RUN pip install --upgrade pip --no-cache-dir -r requirements.txt

# Copy the entire app directory
COPY ./app .

# Create a writable directory and set permissions
RUN mkdir -p /app/cache && \
    chown -R 1000:1000 /app && \
    chmod -R 755 /app

# Set environment variables for temp files
ENV XDG_CACHE_HOME=/app/cache \
    LITELLM_CACHE_DIR=/app/cache

ENV LYZR_CACHE_DIR=/app/cache/lyzr


USER 1000

EXPOSE 8501

CMD ["streamlit", "run", "app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]  # Bind to all interfaces


     