# ============================================================
# apps/backend/Dockerfile
# Python Flask application
# ============================================================

FROM python:3.11-slim AS builder
# python:3.11-slim → Python with minimal OS packages
# slim → removes dev tools, man pages (~50% smaller)

WORKDIR /app

# Copy requirements first (Docker layer caching)
COPY src/requirements.txt .
# WHY COPY requirements first?
# Docker caches each layer
# requirements.txt rarely changes
# → pip install layer is CACHED on rebuild
# → only rebuilds if requirements.txt changes
# If we copied src/ first → cache busted every code change

RUN pip install --no-cache-dir -r requirements.txt
# --no-cache-dir → don't cache pip downloads
#                  keeps image smaller
#                  CI/CD always gets fresh packages

COPY src/ .

FROM python:3.11-slim
# Fresh slim image for production
# No build tools from builder stage

WORKDIR /app

# Create non-root user
RUN groupadd -g 1001 appgroup && \
    useradd -u 1001 -g appgroup -s /bin/false appuser
# groupadd/useradd → Linux (not alpine) syntax
# -s /bin/false → no shell login (security)

COPY --from=builder /app .
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
# Copy installed packages from builder

USER appuser
# USER → switch to non-root user
#        all subsequent commands run as appuser
#        CMD also runs as appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python -c "import urllib.request; \
  urllib.request.urlopen('http://localhost:8080/health')" \
  || exit 1

CMD ["python", "app.py"]