import streamlit as st
from lyzr import ChatBot
import oracledb
import os

# Ensure tokenizer directory exists
os.makedirs('/app/cache/litellm/tokenizers', exist_ok=True)

# OCI DB Connection
conn = oracledb.connect(
  user="ADMIN",
  password=st.secrets["DB_PASSWORD"],
  dsn=f"{st.secrets['DB_HOST']}/CLINICDB"
)

# Lyzr AI Setup with explicit configuration
lyzr_bot = ChatBot(
    api_key=st.secrets["LYZR_KEY"],
    config={
        "tokenizer_path": "/app/cache/litellm/tokenizers",
        "cache_dir": "/app/cache/litellm"
    }
)


# Appointment Booking UI
st.title("Clinic Appointment System")
patient_input = st.text_input("Describe your issue:")
if patient_input:
    response = lyzr_bot.chat(f"""
        As a medical appointment assistant, respond to:
        {patient_input}
        Rules:
        - Never diagnose
        - Suggest time slots only
    """)
    st.write(response)

if st.secrets.get("DOCTOR_TOKEN") != os.getenv("SECRET_QR"):  
  st.error("Access restricted"); st.stop()