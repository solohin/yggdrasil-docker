#!/bin/bash
set -ex 

docker rm -f yggdrasil
docker build -t solohin/yggdrasil-network .

# Generate a private key
YGG_PRIVATE_KEY=$(docker run --rm solohin/yggdrasil-network keygen)
echo "YGG_PRIVATE_KEY is: $YGG_PRIVATE_KEY"

# Start docker container
docker run -d --rm --net=host --cap-add=NET_ADMIN --device=/dev/net/tun -e YGG_PRIVATE_KEY="$YGG_PRIVATE_KEY" --name yggdrasil --privileged solohin/yggdrasil-network

# Get your ip
YGG_IP=$(docker exec yggdrasil myip)
echo "YGG_IP is: $YGG_IP"

# Ping yourself
ping6 $YGG_IP -c 3

# Ping yggdrasil website
ping6 319:3cf0:dd1d:47b9:20c:29ff:fe2c:39be -c 5