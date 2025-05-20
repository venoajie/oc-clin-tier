
# First, build the application in the `/app` directory
FROM ghcr.io/astral-sh/uv:bookworm-slim AS builder
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy


# Install OCI CLI + Instant Client (free)
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -O /tmp/instantclient.zip && \
    unzip /tmp/instantclient.zip -d /usr/lib && \
    rm /tmp/instantclient.zip && \
    echo /usr/lib/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig



# Configure the Python directory so it is consistent
ENV UV_PYTHON_INSTALL_DIR=/python

# Only use the managed Python version
ENV UV_PYTHON_PREFERENCE=only-managed

# Install Python before the project for caching
RUN uv python install 3.12

WORKDIR /app
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-dev
COPY . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev

# Then, use a final image without uv
FROM debian:bookworm-slim

# Copy the Python version
COPY --from=builder --chown=python:python /python /python

# Copy the application from the builder
COPY --from=builder --chown=app:app /app /app

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"
# Run the FastAPI application by default
# Uses `fastapi dev` to enable hot-reloading when the `watch` sync occurs
# Uses `--host 0.0.0.0` to allow access from outside the container
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
