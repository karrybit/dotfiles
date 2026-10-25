.PHONY: build test lint

build:
	go build -o bin/pingmon ./cmd/pingmon

test:
	go test ./...

lint:
	golangci-lint run
