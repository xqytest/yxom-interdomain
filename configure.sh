#!/bin/sh

# Download and install xray
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/v2ray /usr/local/bin/nginx

# Remove temporary directory
rm -rf /tmp/xray

# xray new configuration
install -d /usr/local/etc/nginx
cat << EOF > /usr/local/etc/nginx/config.json
{
  "log": {
    "loglevel": "none"
  },
  "inbounds": [
    {
      "port": "$PORT",
      "protocol": "VLESS",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Run xray
/usr/local/bin/nginx -config /usr/local/etc/nginx/config.json
