VERSION ?= $(shell TAG=$$(git describe --tags --abbrev=0 2>/dev/null); HASH=$$(git rev-parse --short HEAD 2>/dev/null); if [ -n "$$TAG" ] && [ -n "$$HASH" ]; then echo "$$TAG-$$HASH"; else echo "v.unknown-$$HASH"; fi)
IMAGE_NAME := ghcr.io/devops202607/kbot

MODULE_PATH := github.com/devops202607/kbot/cmd.appVersion
LDFLAGS := -s -w -X '$(MODULE_PATH)=$(VERSION)'
BINARY_NAME := kbot

.PHONY: all deps build linux arm mac windows image clean

all: build

deps:
	go mod download

build: deps
	CGO_ENABLED=0 go build -v -ldflags "$(LDFLAGS)" -o $(BINARY_NAME) .

linux: deps
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -ldflags "$(LDFLAGS)" -o $(BINARY_NAME)-linux-amd64 .

arm: deps
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -ldflags "$(LDFLAGS)" -o $(BINARY_NAME)-linux-arm64 .

mac: deps
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -ldflags "$(LDFLAGS)" -o $(BINARY_NAME)-darwin-arm64 .

windows: deps
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -ldflags "$(LDFLAGS)" -o $(BINARY_NAME)-windows-amd64.exe .

image:
	docker build -t $(IMAGE_NAME):$(VERSION) .

clean:
	rm -f $(BINARY_NAME) $(BINARY_NAME)-*
	-docker rmi -f $(IMAGE_NAME):$(VERSION)
