postgres:
	docker run --name postgres17 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:17-alpine

mysql:
	docker run --name mysql8 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -d mysql:8

createdb:
	docker exec -it postgres17 createdb --username=root --owner=root gopher_bank

dropdb:
	docker exec -it postgres17 dropdb gopher_bank

migrateup:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/gopher_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/gopher_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/gopher_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/gopher_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/tndgoat/gopherbank/db/sqlc Store

.PHONY: postgres mysql createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test server mock
