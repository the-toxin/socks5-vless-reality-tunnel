# Socks5 to VLESS+REALITY Proxy (based on Xray-core)

## How to Use

```
docker run --rm -it \
  --env OUTBOUND_ADDRESS="<remote-proxy-ip>" \
  --env OUTBOUND_PORT="<remote-proxy-port>" \
  --env OUTBOUND_USER_ID="<remote-proxy-user-id>" \
  --env OUTBOUND_REALITY_PUBLICKEY="<remote-proxy-reality-settings-pkey>" \
  --env OUTBOUND_REALITY_SHORTID="<remote-proxy-reality-settings-shot-id>" \
  --network=host \
  --name socks5-vless-reality-tunnel \
  thetoxin/socks5-vless-reality-tunnel:24.11.21-1-amd64
```
