#!/bin/sh

set -e

echo "waiting for postgres..."

/app/wait-for.sh postgres:5432 -- echo "postgres started"

echo "run db migration"

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"

exec /app/main
