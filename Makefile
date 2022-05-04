.PHONY: run
.SILENT:

run:
	go run cmd/main.go

mod:
	go mod tidy

clean:
	rm -rf test_workspace/*

install:
	go install
