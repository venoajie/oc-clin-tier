FROM python:3.11-slim-bullseye

# Install OCI CLI + Instant Client (free)
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /usr/lib && \
    rm /tmp/instantclient.zip && \
    echo /usr/lib/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig\
    firewall-cmd --zone=public --add-port=8501/tcp --permanent

WORKDIR /app

RUN pip install streamlit==1.29.0 notion-client==2.2.0 lyzr

COPY . .


HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=89.168.104.162"]
