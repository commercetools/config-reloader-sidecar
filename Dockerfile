FROM golang:1.27.0 AS builder
ARG TARGETARCH
ARG TARGETOS

WORKDIR /workspace

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o config-reloader-sidecar .

# Runtime

FROM gcr.io/distroless/static-debian13@sha256:448810357cc8e67b7208988abdba0f5ec3d3aebee0a5b13eb624979792cffc0f

COPY --from=builder /workspace/config-reloader-sidecar .

CMD ["/config-reloader-sidecar"]
