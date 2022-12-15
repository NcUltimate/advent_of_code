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
  part1.DrawPaths()
  part1.PourSand()
  part1.Print()

  part2 := NewCave(string(data), false)
  part2.DrawPaths()
  part2.PourSand()
  part2.Print()
}
