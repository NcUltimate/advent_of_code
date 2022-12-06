package main

import (
	"fmt"
	"io/ioutil"
	"os"
  "strings"
  "strconv"
)

func main() {
  runLength := os.Args[2]
  length, lerr := strconv.Atoi(runLength)
  if lerr != nil {
     fmt.Println("Error:", lerr)
     os.Exit(1)
  }

	filename := os.Args[1]
	data, ferr := ioutil.ReadFile(filename)
	if ferr != nil {
		fmt.Println("Error:", ferr)
		os.Exit(1)
	}

  for _, line := range strings.Split(string(data), "\n") {
    if len(line) > 0 {
      fmt.Printf("%s - %v\n", line, Day06(line, length))
    }
  }
}
