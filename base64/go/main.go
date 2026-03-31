package main

import (
	"fmt"

	"github.com/binary141/based/base64"
)

func main() {
	val := base64.Base64Encode([]byte("foobar"))

	fmt.Printf("encoded: %s\n", val)
}
