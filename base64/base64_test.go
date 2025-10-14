package base64

import (
	"testing"
)

func TestBase64(t *testing.T) {
	tests := map[string]string{
		"":       "",
		"f":      "Zg==",
		"fo":     "Zm8=",
		"foo":    "Zm9v",
		"foob":   "Zm9vYg==",
		"fooba":  "Zm9vYmE=",
		"foobar": "Zm9vYmFy",
	}

	for test, result := range tests {
		res := Base64Encode(test)

		if result != res {
			t.Error(result, res)
		}
	}
}
