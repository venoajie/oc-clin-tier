FROM python:3.13-slim-bullseye

# Install OCI CLI + Instant Client (free)
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /usr/lib && \
    rm /tmp/instantclient.zip && \
    echo /usr/lib/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

WORKDIR /app

RUN pip install streamlit==1.29.0 notion-client==2.2.0 lyzr==0.0.8

COPY app/ .

CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]