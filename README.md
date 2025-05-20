.
├── .github/
│   └── workflows/
│       ├── terraform-validate.yml  # Auto-validates TF configs
│       └── docker-build.yml        # Builds/pushes Docker image
├── terraform/
│   ├── main.tf                     # OCI free-tier resources
│   ├── variables.tf                # Compartment/tenancy IDs
│   ├── outputs.tf                  # DB host/IP outputs
│   └── hipaa/
│       ├── encryption.tf           # KMS keys (free)
│       └── audit.tf                # Free audit logs
├── docker/
│   ├── Dockerfile                  # Streamlit + OCI client
│   └── docker-compose.yml          # Local dev setup
├── app/
│   ├── app.py                      # Streamlit frontend
│   ├── db.py                       # OCI DB connection
│   └── tests/                      # Pytest unit tests
│       ├── test_db.py
│       └── conftest.py
├── scripts/
│   ├── deploy.sh                   # 1-click deploy
│   └── stop_dev_resources.sh       # Nightly cost saver
└── README.md                       # Setup guide
