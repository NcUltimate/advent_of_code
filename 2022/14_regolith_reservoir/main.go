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

  part1 := NewCave(string(data), true)
  part1.DripSand()
  part1.Print()

  part2 := NewCave(string(data), false)
  part2.DripSand()
  part2.Print()
}
