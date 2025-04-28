# syntax=docker/dockerfile:1
FROM python:3.11-slim

# 1 . Optional OS-level build tools
#RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*

    
# 2 . Create non-root user & set workdir
RUN useradd -m appuser
WORKDIR /app

# 3 . Copy dependency list and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3.5 needed Pre-download the sentence-transformers model so it’s cached in the image
#RUN python - <<'PY'
#from sentence_transformers import SentenceTransformer
#SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
#PY
# Pre-download the sentence-transformers model
#RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')"
# Switch to appuser to download model into app-owned cache
#USER appuser
#RUN mkdir -p /app/model_cache && \
#    HF_HOME=/app/model_cache python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')"
#USER root
#ENV HF_HOME=/app/model_cache
# Create cache dir as root, give it to appuser, download model, then switch to appuser
RUN mkdir -p /app/model_cache && \
    chown -R appuser:appuser /app/model_cache && \
    HF_HOME=/app/model_cache python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')"

ENV HF_HOME=/app/model_cache
USER appuser


# 4 . Copy the rest of the source code
COPY . .

# 5 . Expose the port FastAPI listens on
ENV PORT=8080
USER appuser
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
