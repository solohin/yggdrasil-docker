package main

//most of this code copied from yggdrasil github and belongs to them

import (
	"crypto/ed25519"
	"encoding/hex"
	"fmt"
	"runtime"
	"time"
)

type keySet struct {
	priv ed25519.PrivateKey
	pub  ed25519.PublicKey
}

const WAIT_TIME = time.Second * 1

func main() {
	start := time.Now()

	threads := runtime.GOMAXPROCS(0)
	var currentBest keySet
	newKeys := make(chan keySet, threads)
	for i := 0; i < threads; i++ {
		go doKeys(newKeys)
	}
	for {
		newKey := <-newKeys
		if isBetter(currentBest.pub, newKey.pub) || len(currentBest.pub) == 0 {
			currentBest = newKey
		}
		elapsed := time.Since(start)

		if elapsed > WAIT_TIME && len(currentBest.pub) != 0 {
			fmt.Print(hex.EncodeToString(currentBest.priv))
			return
		}
	}
}

func isBetter(oldPub, newPub ed25519.PublicKey) bool {
	for idx := range oldPub {
		if newPub[idx] < oldPub[idx] {
			return true
		}
		if newPub[idx] > oldPub[idx] {
			break
		}
	}
	return false
}

func doKeys(out chan<- keySet) {
	bestKey := make(ed25519.PublicKey, ed25519.PublicKeySize)
	for idx := range bestKey {
		bestKey[idx] = 0xff
	}
	for {
		pub, priv, err := ed25519.GenerateKey(nil)
		if err != nil {
			panic(err)
		}
		if !isBetter(bestKey, pub) {
			continue
		}
		bestKey = pub
		out <- keySet{priv, pub}
	}
}
