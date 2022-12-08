package main

import (
	"fmt"
	"io/ioutil"
	"os"
  "strings"
)

func main() {
	filename := os.Args[1]
	data, ferr := ioutil.ReadFile(filename)
	if ferr != nil {
		fmt.Println("Error:", ferr)
		os.Exit(1)
	}

  sizes := Day07(strings.Split(string(data), "\n"))

  fmt.Printf("Root size: %v\n", sizes[0])
  fmt.Printf("Delete Dir Size: %v\n", sizes[1])
  fmt.Printf("Total size < 100k: %v\n", sizes[2])
}
