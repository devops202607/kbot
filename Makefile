VERSION ?= $(shell git describe --tags --always 2>/dev/null | sed 's/^v/v/' | sed 's/-g/-/' || echo "v.unknown")
REGISTRY ?= someregistry
IMAGE_NAME := kbot

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
	docker build -t $(REGISTRY)/$(IMAGE_NAME):$(VERSION) .

clean:
	rm -f $(BINARY_NAME) $(BINARY_NAME)-*
	-docker rmi -f $(REGISTRY)/$(IMAGE_NAME):$(VERSION)
