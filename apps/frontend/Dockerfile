# ============================================================
# apps/frontend/Dockerfile
# Multi-stage build for smallest possible image
# ============================================================

# Stage 1: Build stage
FROM node:24-alpine AS builder

WORKDIR /app

COPY src/ .

# Stage 2: Production stage
FROM nginx:1.25-alpine

LABEL maintainer="enterprise-platform"
# LABEL → metadata (shown in docker inspect)
# good practice for tracking
RUN mkdir -p /var/cache/nginx/client_temp \
  /var/cache/nginx/proxy_temp \
  /var/cache/nginx/fastcgi_temp \
  /var/cache/nginx/uwsgi_temp \
  /var/cache/nginx/scgi_temp && \
    chown -R nginx:nginx \
      /var/cache/nginx \
      /var/log/nginx \
      /etc/nginx/conf.d && \
    chmod -R 755 /var/cache/nginx && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid

# Copy built files from builder stage
COPY --from=builder /app /usr/share/nginx/html
# COPY --from=builder → copy FROM the builder stage
#                       not from host filesystem
# /app → source path in builder stage
# /usr/share/nginx/html → where nginx serves files

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf
USER nginx
EXPOSE 80
# EXPOSE → documents which port app listens on
#          doesn't actually open port
#          informational + used by docker-compose

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --quiet --tries=1 --spider \
  http://localhost/health || exit 1
# HEALTHCHECK → Docker checks container health
# --interval  → check every 30 seconds
# --timeout   → give up after 3 seconds
# --retries   → fail after 3 attempts
# CMD         → command to run for health check
# exit 1      → non-zero exit = unhealthy

CMD ["nginx", "-g", "daemon off;"]
# CMD → default command when container starts
# nginx -g "daemon off;" → run nginx in foreground
# Containers need foreground process to stay alive