package main

import (
  "fmt"
	"io/ioutil"
	"os"
)

func main() {
	filename := os.Args[1]
	data, ferr := ioutil.ReadFile(filename)
	if ferr != nil {
		fmt.Println("Error:", ferr)
		os.Exit(1)
	}

  Part1(string(data))
  Part2(string(data))
}
