package main

import (
	"fmt"
	"io/ioutil"
	"os"
  "strings"
)

func Day06(str string) int {
  strlen := len(str);
  counts := make(map[byte]int)

  for i := 0; i < strlen; i++ {
    if(i > 3) {
      counts[str[i-4]] -= 1;
      if(counts[str[i-4]] == 0) {
        delete(counts, str[i-4])
      }
    }

    if _, ok := counts[str[i]]; ok {
      counts[str[i]] += 1;
    } else {
      counts[str[i]] = 1
    }

    if len(counts) == 4 {
      return i + 1
    }
  }

  return -1
}

func main() {
	filename := os.Args[1]
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}

  for _, line := range strings.Split(string(data), "\n") {
    if len(line) > 0 {
      fmt.Printf("%s - %v\n", line, Day06(line))
    }
  }
}
