.SILENT:
.EXPORT_ALL_VARIABLES:
.PHONY: all test build run run-build clean rebuild

APP_NAME := {{.AppName}}
VERSION := v1.0.0
TAG := $(shell git describe --abbrev=0 --tags)
COMMIT_LAST := $(shell git rev-parse HEAD)
COMMIT_DATE := $(shell git log -1 --date=format:"%Y-%m-%dT%TZ" --format="%ad")
FORTUNE_COOKIE := $(shell curl -s http://yerkee.com/api/fortune/cookie | sed -e 's/[^a-zA-Z0-9/ ,.]*//g;s/fortune//g;s/ntt//g')

LDFLAGS="-X main.appName=$(BUILD_NAME) \
		-X 'main.version=1.0.0' \
		-X 'main.tag=$(TAG)' \
		-X 'main.commit=$(COMMIT_LAST)' \
		-X 'main.fortuneCookie=$(FORTUNE_COOKIE)' \
		-X 'main.date=$(COMMIT_DATE)'"
all: run

lint:
	golangci-lint run -c golangci-lint.yml

test:
	go clean -testcache ./...
	go test -v -p 4 ./...

check: test lint

gen:
	go generate ./...

build: test
	go build -ldflags=$(LDFLAGS) -o ./build/$(APP_NAME) ./cmd/.

run:
	cd cmd; go run -ldflags=$(LDFLAGS) main.go -c config.yaml

run-build: build
	cd cmd; ./$(APP_NAME)

run-docker: build
	docker build -t $(APP_NAME) . && docker run -it $(APP_NAME)

run-docker-local: mod vendor
	docker build -t $(APP_NAME) --build-arg -f Dockerfile.local . \
	&& docker run -p 40012:40012 $(APP_NAME)

clean:
	go clean ./...
	rm -f ./cmd/$(APP_NAME)

rebuild: clean build

vendor:
	go mod vendor

mod:
	go mod tidy

# TODO: setup swagger
swagger-generate:
	swag init -g internal/app/doc.go
	rm docs/docs.go docs/swagger.json
	redoc-cli bundle -o docs/index.html docs/swagger.yaml

swagger-serve:
	redoc-cli serve docs/swagger.yaml

swagger: swagger-generate swagger-serve

# install geth
OS = $(shell uname -s)

install-geth:
ifeq ($(OS),Darwin)
	brew tap ethereum/ethereum
	brew install ethereum
else
	sudo add-apt-repository -y ppa:ethereum/ethereum && \
	sudo apt update -y && \
	sudo apt install -y ethereum
endif

# ubuntu
# install sudo snap install goimports-reviser --devmode

# mac
# brew tap incu6us/homebrew-tap
# brew install incu6us/homebrew-tap/goimports-reviser

imports:
	$(shell find . -name \*.go -and -not -name '**mock*.go' -and -not -name 'validate.go' -exec sh -c 'goimports -w {}; goimports-reviser -project-name ${APP_NAME} -file-path {}' \;)
