package main

import (
	"crypto/ed25519"
	"encoding/hex"
	"fmt"
	"net"
	"os"
	"time"

	"github.com/yggdrasil-network/yggdrasil-go/src/address"
)

const WAIT_TIME = time.Second * 1

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: ygg-private-to-ip <private key>")
		os.Exit(1)
	}
	privKeyString := os.Args[1]
	if len(privKeyString) != 128 {
		fmt.Printf("Invalid private key length: %d\n", len(privKeyString))
		os.Exit(1)
	}
	privBytes, err := hex.DecodeString(privKeyString)
	if err != nil {
		panic(err)
	}
	pk := ed25519.PrivateKey(privBytes)
	publicKey := ed25519.PrivateKey(pk).Public().(ed25519.PublicKey)
	addr := address.AddrForKey(publicKey)
	fmt.Println(net.IP(addr[:]).String())
}
