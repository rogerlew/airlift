FROM golang:1.25-bookworm AS build
WORKDIR /src
ENV GOPROXY=https://proxy.golang.org
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /airliftd ./cmd/airliftd

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /airliftd /usr/local/bin/airliftd
EXPOSE 60606
ENTRYPOINT ["/usr/local/bin/airliftd"]
