package main

import (
	"fmt"
	"io/ioutil"
	"os"
  "strings"
  "strconv"
)

func main() {
	filename := os.Args[1]
	data, ferr := ioutil.ReadFile(filename)
	if ferr != nil {
		fmt.Println("Error:", ferr)
		os.Exit(1)
	}

  tailLen := os.Args[2]
  length, _ := strconv.Atoi(tailLen)

  inst := strings.Split(string(data), "\n")
  visited := Day09(inst, length, false)
  fmt.Printf("Visited Spaces: %v\n", visited)
}
