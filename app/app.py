import streamlit as st
from lyzr import ChatBot
import oracledb
import os

# Configure LiteLLM cache path before initializing ChatBot
os.environ['LITELLM_CACHE_DIR'] = '/app/cache/litellm'
os.makedirs('/app/cache/litellm/tokenizers', exist_ok=True)

# OCI DB Connection
conn = oracledb.connect(
  user="ADMIN",
  password=st.secrets["DB_PASSWORD"],
  dsn=f"{st.secrets['DB_HOST']}/CLINICDB"
)

# Lyzr AI Setup with explicit tokenizer path
lyzr_bot = ChatBot(
    api_key=st.secrets["LYZR_KEY"],
    tokenizer_path="/app/cache/litellm/tokenizers"
)

# Rest of your existing code...