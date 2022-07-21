# Yggdrasil network in docker
With us-based peer list

## Usage
```bash
docker pull ghcr.io/solohin/yggdrasil-docker:main
# Generate a private key
YGG_PRIVATE_KEY=$(docker run --rm ghcr.io/solohin/yggdrasil-docker:main keygen)
echo "YGG_PRIVATE_KEY is: $YGG_PRIVATE_KEY"

# Start docker container
docker run -d --restart=always --net=host --cap-add=NET_ADMIN --device=/dev/net/tun -e YGG_PRIVATE_KEY="$YGG_PRIVATE_KEY" --name yggdrasil --privileged ghcr.io/solohin/yggdrasil-docker:main

# Get your ip
YGG_IP=$(docker exec yggdrasil myip)
echo "YGG_IP is: $YGG_IP"

# Ping yourself
ping6 $YGG_IP -c 3

# Ping yggdrasil website
ping6 319:3cf0:dd1d:47b9:20c:29ff:fe2c:39be -c 5
```