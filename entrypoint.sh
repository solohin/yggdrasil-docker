#!/bin/sh
set -ex 


if [ "$1" = "keygen" ]; then
    /usr/bin/yggkeygen
    exit 0
fi

sysctl net.ipv6.conf.all.disable_ipv6=0 || true


if [ -z "${YGG_PRIVATE_KEY}" ]; then
  echo "YGG_PRIVATE_KEY is not set. Generting a new private key"
  YGG_PRIVATE_KEY=$(yggkeygen)
fi

cat /etc/yggdrasil.template.json | jq -r ".PrivateKey = \"$YGG_PRIVATE_KEY\"" > /etc/yggdrasil.json

yggdrasil -useconffile /etc/yggdrasil.json
