FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.22 AS builder

WORKDIR /app
COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o kbot .

# Stage 2
FROM quay.io/projectquay/golang:1.22

WORKDIR /app
COPY --from=builder /app/kbot /app/kbot

ENTRYPOINT ["/app/kbot"]
