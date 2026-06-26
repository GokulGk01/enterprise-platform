# ============================================================
# apps/backend/Dockerfile
# Python Flask application
# ============================================================

FROM python:3.11-slim AS builder

WORKDIR /app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

# Production stage
FROM python:3.11-slim

WORKDIR /app

RUN groupadd -g 1001 appgroup && useradd -u 1001 -g appgroup -s /bin/false appuser

COPY --from=builder /app .
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --retries=3 

CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

CMD ["python", "app.py"]
