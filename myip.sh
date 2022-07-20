#!/bin/sh
set -e
PRIVATE_KEY=$(cat /etc/yggdrasil.json | jq -r ".PrivateKey")
ygg-private-to-ip $PRIVATE_KEY