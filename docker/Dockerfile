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


# Copy requirements first for caching
COPY ./app/requirements.txt .

RUN pip install  --upgrade pip streamlit notion-client lyzr 

# Copy the entire app directory
COPY ./app .

# Verify file exists
RUN ls -l /app/app.py


HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "app.py",\
            "--server.port=8501", \
            "--server.address=89.168.104.162",\
            "--server.headless=true"\
            ]