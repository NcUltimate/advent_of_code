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

  forest := Forester(string(data))

  visible := Part1(forest)
  fmt.Printf("Visible Trees: %v\n", visible)

  scenicScore := Part2(forest)
  fmt.Printf("Scenic Score: %v\n", scenicScore)
}
