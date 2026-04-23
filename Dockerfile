# Build stage
FROM golang:1.25-alpine3.23 AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main main.go

RUN apk add --no-cache curl

RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.19.1/migrate.linux-amd64.tar.gz \
  | tar -xz

# Run stage
FROM alpine:3.23

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/migrate .

COPY start.sh .
COPY wait-for.sh .

COPY app.env .
COPY db/migration ./migration

RUN chmod +x start.sh wait-for.sh

EXPOSE 8080

ENTRYPOINT ["/app/start.sh"]
