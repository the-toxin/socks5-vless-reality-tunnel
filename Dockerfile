FROM golang:alpine AS builder

ENV XRAY_CORE_VERSION="v24.11.21"

WORKDIR /app

RUN apk add --no-cache git  && \
    git clone https://github.com/XTLS/Xray-core.git . && \
    git checkout ${XRAY_CORE_VERSION} && \
    go mod download && \
    go build -o xray /app/main/


FROM alpine:latest AS runner
LABEL org.opencontainers.image.source="https://github.com/the-toxin/socks5-vless-reality-tunnel"
LABEL version="24.11.21-1"

WORKDIR /

COPY --from=builder /app/xray /

COPY ./entrypoint.sh /
COPY ./config.json /

RUN apk add --no-cache tzdata ca-certificates jq curl libqrencode-tools && \
    mkdir -p /var/log/xray &&\
    wget -O /geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat && \
    wget -O /geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
