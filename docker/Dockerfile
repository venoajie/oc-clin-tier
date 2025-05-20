FROM python:3.11-slim-bullseye

# Install OCI CLI + Instant Client (free)
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /usr/lib && \
    rm /tmp/instantclient.zip && \
    echo /usr/lib/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig\
    iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8501 -j ACCEPT

WORKDIR /app

RUN pip install streamlit==1.29.0 notion-client==2.2.0 lyzr

COPY . .

CMD ["streamlit", "run", "app.py", "--server.address=89.168.104.162:8501"]