IMAGE_TAG ?= kbot:latest
BINARY_NAME ?= kbot

.PHONY: all build linux arm mac windows image clean

all: build

build:
	go build -o $(BINARY_NAME) .

linux:
	GOOS=linux GOARCH=amd64 go build -o $(BINARY_NAME)-linux-amd64 .

arm:
	GOOS=linux GOARCH=arm64 go build -o $(BINARY_NAME)-linux-arm64 .

mac:
	GOOS=darwin GOARCH=arm64 go build -o $(BINARY_NAME)-darwin-arm64 .

windows:
	GOOS=windows GOARCH=amd64 go build -o $(BINARY_NAME)-windows-amd64.exe .

image:
	docker build -t $(IMAGE_TAG) .

clean:
	rm -f $(BINARY_NAME) $(BINARY_NAME)-*
	-docker rmi $(IMAGE_TAG)
