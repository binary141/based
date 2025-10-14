// Package base64 holds the functions to base64 encode a string
package base64

var intToLetters map[int]byte

const PADDING = '='

func init() {
	intToLetters = map[int]byte{
		0:  'A',
		1:  'B',
		2:  'C',
		3:  'D',
		4:  'E',
		5:  'F',
		6:  'G',
		7:  'H',
		8:  'I',
		9:  'J',
		10: 'K',
		11: 'L',
		12: 'M',
		13: 'N',
		14: 'O',
		15: 'P',
		16: 'Q',
		17: 'R',
		18: 'S',
		19: 'T',
		20: 'U',
		21: 'V',
		22: 'W',
		23: 'X',
		24: 'Y',
		25: 'Z',
		26: 'a',
		27: 'b',
		28: 'c',
		29: 'd',
		30: 'e',
		31: 'f',
		32: 'g',
		33: 'h',
		34: 'i',
		35: 'j',
		36: 'k',
		37: 'l',
		38: 'm',
		39: 'n',
		40: 'o',
		41: 'p',
		42: 'q',
		43: 'r',
		44: 's',
		45: 't',
		46: 'u',
		47: 'v',
		48: 'w',
		49: 'x',
		50: 'y',
		51: 'z',
		52: '0',
		53: '1',
		54: '2',
		55: '3',
		56: '4',
		57: '5',
		58: '6',
		59: '7',
		60: '8',
		61: '9',
		62: '-', // (minus)
		63: '_', // (underline)
		64: '=', // (pad)
	}
}

// f -> []byte{0,1,1,0,0,1,1,0}
func intToBits(i int32) []byte {
	a := byte(i >> 7 & 0x1)
	b := byte(i >> 6 & 0x1)
	c := byte(i >> 5 & 0x1)
	d := byte(i >> 4 & 0x1)
	e := byte(i >> 3 & 0x1)
	f := byte(i >> 2 & 0x1)
	g := byte(i >> 1 & 0x1)
	h := byte(i >> 0 & 0x1)

	return []byte{a, b, c, d, e, f, g, h}
}

func Base64Encode(str string) string {
	bitWidth := 6

	var bits []byte

	// get all the bits that make up the string
	for _, s := range str {
		bits = append(bits, intToBits(s)...)
	}

	if len(bits) == 0 {
		return ""
	}

	// add padding if needed
	paddingNeeded := bitWidth - (len(bits) % bitWidth)
	if paddingNeeded == bitWidth {
		paddingNeeded = 0
	}

	for range paddingNeeded {
		bits = append(bits, 0)
	}

	var letters []byte

	for i := 0; i <= len(bits)-bitWidth; i += bitWidth {
		idx := (int(bits[i]) << 5)
		idx += (int(bits[i+1]) << 4)
		idx += (int(bits[i+2]) << 3)
		idx += (int(bits[i+3]) << 2)
		idx += (int(bits[i+4]) << 1)
		idx += (int(bits[i+5]) << 0)

		letter := intToLetters[idx]

		letters = append(letters, letter)
	}

	// two padding digits equal a single padding character
	for range paddingNeeded / 2 {
		letters = append(letters, PADDING)
	}

	return string(letters)
}
