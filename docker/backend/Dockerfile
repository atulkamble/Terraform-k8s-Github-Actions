# Stage 1: Build the Go binary
FROM golang:1.19 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o backend main.go

# Stage 2: Run the binary
FROM debian:bullseye-slim

WORKDIR /app

# Fiber needs timezone data
RUN apt-get update && apt-get install -y tzdata && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/backend /app/backend

# Add environment variable definitions (optional for clarity/documentation)
ENV DB_HOST=localhost \
    DB_USER=postgres \
    DB_PASSWORD=postgres \
    DB_NAME=employeedb \
    DB_PORT=5432 \
    ALLOWED_ORIGINS=http://localhost:3000

EXPOSE 8080

CMD ["./backend"]
