# Stage 1: Build
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy dependency files first (for caching)
COPY app/go.mod ./
RUN go mod download

# Copy source code
COPY app/ .

# Build binary
RUN go build -o app

# Stage 2: Run 
FROM alpine:3.18

WORKDIR /app

# Create non-root user
RUN adduser -D appuser

# Copy binary from builder
COPY --from=builder /app/app .

# Switch to non-root user
USER appuser

# Expose port (assume 8080)
EXPOSE 8080

# Run app
CMD ["./app"]
