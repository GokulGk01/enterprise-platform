# ============================================================
# apps/frontend/Dockerfile
# Multi-stage build for smallest possible image
# ============================================================

# Stage 1: Build stage
FROM node:20-alpine AS builder
# node:20-alpine → small Node.js image (~50MB)
# alpine         → minimal Linux (5MB base)
# AS builder     → names this stage "builder"
#                  referenced in stage 2

WORKDIR /app
# WORKDIR → sets working directory
#           creates it if doesn't exist
#           all subsequent commands run here

COPY src/ .
# COPY src/ . → copy src/ from host into /app in container
# . → current directory (WORKDIR = /app)

# Stage 2: Production stage
FROM nginx:1.25-alpine
# Start fresh from nginx image
# NOTHING from builder stage carried over automatically
# Only what we explicitly COPY --from=builder

LABEL maintainer="enterprise-platform"
LABEL version="1.0.0"
# LABEL → metadata (shown in docker inspect)
# good practice for tracking

# Copy built files from builder stage
COPY --from=builder /app /usr/share/nginx/html
# COPY --from=builder → copy FROM the builder stage
#                       not from host filesystem
# /app → source path in builder stage
# /usr/share/nginx/html → where nginx serves files

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup
# addgroup → create group (alpine syntax)
# adduser  → create user in that group
# -S       → system user (no password, no shell)
# -g 1001  → group ID (non-root)
# -u 1001  → user ID (non-root)
# Why? Running as root in container is a security risk
#      if container is compromised, attacker gets root

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