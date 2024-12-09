#!/bin/sh

set -e

__XRAY_CONFIG="/config.json"
__XRAY_CONFIG_TMP="/config.json.tmp"

# Set conf vars default values 
if [ -z "$LOG_LEVEL" ]; then
    LOG_LEVEL="info"
    echo "LOG_LEVEL is not set. Use default value: ${LOG_LEVEL}"
fi
if [ -z "$LOG_ACCESS_FILE" ]; then
    LOG_ACCESS_FILE="/var/log/xray/access.log"
    echo "LOG_ACCESS_FILE is not set. Use default value: ${LOG_ACCESS_FILE}"
fi
if [ -z "$LOG_ERROR_FILE" ]; then
    LOG_ERROR_FILE="/var/log/xray/error.log"
    echo "LOG_ERROR_FILE is not set. Use default value: ${LOG_ERROR_FILE}"
fi
if [ -z "$INBOUND_LISTEN" ]; then
    INBOUND_LISTEN="127.0.0.1"
    echo "INBOUND_LISTEN is not set. Use default value: ${INBOUND_LISTEN}"
fi
if [ -z "$INBOUND_PORT" ]; then
    INBOUND_PORT="10800"
    echo "INBOUND_PORT is not set. Use default value: ${INBOUND_PORT}"
fi
if [ -z "$OUTBOUND_ADDRESS" ]; then
    echo "An ERROR occurred! OUTBOUND_ADDRESS is not set" && exit 1
fi
if [ -z "$OUTBOUND_PORT" ]; then
    echo "An ERROR occurred! OUTBOUND_PORT is not set"  && exit 1
fi
if [ -z "$OUTBOUND_USER_ID" ]; then
    echo "An ERROR occurred! OUTBOUND_USER_ID is not set" && exit 1
fi
if [ -z "$OUTBOUND_REALITY_FINGERPRINT" ]; then
    OUTBOUND_REALITY_FINGERPRINT="chrome"
    echo "OUTBOUND_REALITY_FINGERPRINT is not set. Use default value: ${OUTBOUND_REALITY_FINGERPRINT}"
fi
if [ -z "$OUTBOUND_REALITY_SERVERNAME" ]; then
    OUTBOUND_REALITY_SERVERNAME="speed.cloudflare.com"
    echo "OUTBOUND_REALITY_SERVERNAME is not set. Use default value: ${OUTBOUND_REALITY_SERVERNAME}"
fi
if [ -z "$OUTBOUND_REALITY_PUBLICKEY" ]; then
    echo "An ERROR occurred! OUTBOUND_REALITY_PUBLICKEY is not set" && exit 1
fi
if [ -z "$OUTBOUND_REALITY_SPIDERX" ]; then
    OUTBOUND_REALITY_SPIDERX=""
    echo "OUTBOUND_REALITY_SPIDERX is not set. Use default value: ${OUTBOUND_REALITY_SPIDERX}"
fi
if [ -z "$OUTBOUND_REALITY_SHORTID" ]; then
    OUTBOUND_REALITY_SHORTID=""
    echo "OUTBOUND_REALITY_SHORTID is not set. Use default value: ${OUTBOUND_REALITY_SHORTID}"
fi

# Create service config
jq ".log.loglevel=\"$LOG_LEVEL\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".log.access=\"$LOG_ACCESS_FILE\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".log.error=\"$LOG_ERROR_FILE\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".inbounds[0].listen=\"$INBOUND_LISTEN\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".inbounds[0].port=$INBOUND_PORT" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].settings.vnext[0].address=\"$OUTBOUND_ADDRESS\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].settings.vnext[0].port=$OUTBOUND_PORT" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].settings.vnext[0].users[0].id=\"$OUTBOUND_USER_ID\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].streamSettings.realitySettings.fingerprint=\"$OUTBOUND_REALITY_FINGERPRINT\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].streamSettings.realitySettings.serverName=\"$OUTBOUND_REALITY_SERVERNAME\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].streamSettings.realitySettings.publicKey=\"$OUTBOUND_REALITY_PUBLICKEY\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].streamSettings.realitySettings.spiderX=\"$OUTBOUND_REALITY_SPIDERX\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"
jq ".outbounds[0].streamSettings.realitySettings.shortId=\"$OUTBOUND_REALITY_SHORTID\"" "${__XRAY_CONFIG}" > "${__XRAY_CONFIG_TMP}" && mv "${__XRAY_CONFIG_TMP}" "${__XRAY_CONFIG}"

# Run service
exec /xray -config "${__XRAY_CONFIG}"
