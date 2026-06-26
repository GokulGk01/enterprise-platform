# ============================================================
# apps/frontend/Dockerfile
# ============================================================

FROM node:20-alpine AS builder

WORKDIR /app
COPY src/ .

FROM nginx:1.25-alpine

LABEL maintainer="enterprise-platform"

# Fix ALL nginx permission issues for non-root
RUN mkdir -p \
      /var/cache/nginx/client_temp \
      /var/cache/nginx/proxy_temp \
      /var/cache/nginx/fastcgi_temp \
      /var/cache/nginx/uwsgi_temp \
      /var/cache/nginx/scgi_temp \
      /var/run/ && \
    # Fix ownership of ALL dirs nginx needs
    chown -R nginx:nginx \
      /var/cache/nginx \
      /var/log/nginx \
      /var/run/ \
      /etc/nginx/conf.d && \
    chmod -R 755 \
      /var/cache/nginx \
      /var/run/ && \
    # Pre-create pid file with correct ownership
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid && \
    # Remove default nginx.conf user directive
    # (causes warning when not running as root)
    sed -i '/^user /d' /etc/nginx/nginx.conf

COPY --from=builder /app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix ownership of html files
RUN chown -R nginx:nginx /usr/share/nginx/html

# Switch to non-root nginx user
USER nginx

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --quiet --tries=1 --spider \
  http://localhost:80/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
