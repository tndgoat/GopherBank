postgres:
	docker run --name postgres17 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:17-alpine

mysql:
	docker run --name mysql8 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -d mysql:8

createdb:
	docker exec -it postgres17 createdb --username=root --owner=root gopher_bank

dropdb:
	docker exec -it postgres17 dropdb gopher_bank

migrateup:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/gopher_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/gopher_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

.PHONY: postgres mysql createdb dropdb migrateup migratedown sqlc test server
