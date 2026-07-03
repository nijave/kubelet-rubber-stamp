FROM docker.io/library/golang:1.26 AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG TARGETOS=linux
ARG TARGETARCH=amd64
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o kubelet-rubber-stamp cmd/manager/main.go

FROM scratch

COPY --from=builder /src/kubelet-rubber-stamp /kubelet-rubber-stamp

ENTRYPOINT ["/kubelet-rubber-stamp", "-logtostderr"]
