# ============================================================
# apps/api/Dockerfile
# Go application — smallest possible final image
# ============================================================

FROM golang:1.21-alpine AS builder
# golang:1.21-alpine → Go compiler on Alpine

WORKDIR /app

# Initialize Go module
COPY src/go.mod* src/go.sum* ./
# go.mod → module definition (like package.json)
# go.sum → dependency checksums (security)
# Copy first for layer caching

RUN go mod download 2>/dev/null || true
# Download dependencies (cached layer)

COPY src/ .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o api-server \
    -ldflags="-w -s" \
    .
# CGO_ENABLED=0 → no C dependencies (static binary)
# GOOS=linux    → build for Linux (even on Mac)
# GOARCH=amd64  → build for x86_64
# -ldflags="-w -s" → strip debug info → smaller binary
# Result: single static binary, no runtime needed

# Production stage — SCRATCH (empty image)
FROM scratch
# scratch → completely empty image
# No OS, no shell, no nothing
# Only our binary
# MOST SECURE option — no attack surface
# Image size: ~10MB (just the binary)

COPY --from=builder /app/api-server /api-server
# Copy only the compiled binary

EXPOSE 9090

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD ["/api-server", "health"] || exit 1

CMD ["/api-server"]