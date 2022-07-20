# Compiling
FROM golang:1.17-alpine AS builder
ENV CGO_ENABLED 0
ENV TZ=Europe/Moscow

RUN apk add git

WORKDIR /src
RUN git clone https://github.com/yggdrasil-network/yggdrasil-go

WORKDIR /src/yggdrasil-go
RUN ./build

COPY go.* /src/utils/
COPY cmd /src/utils/cmd/
WORKDIR /src/utils/
RUN go build ./cmd/yggkeygen
RUN go build ./cmd/ygg-private-to-ip

# Final image
FROM alpine:3.16
RUN apk add jq
COPY --from=builder /src/yggdrasil-go/yggdrasil /src/yggdrasil-go/yggdrasilctl  /src/utils/ygg-private-to-ip /src/utils/yggkeygen /usr/bin/
COPY entrypoint.sh /entrypoint.sh
COPY yggdrasil.template.json /etc/yggdrasil.template.json
COPY myip.sh /usr/bin/myip
RUN chmod +x /usr/bin/myip

ENTRYPOINT [ "sh", "/entrypoint.sh" ]