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

  cycles := strings.Split(string(data), "\n")

  signalStrength := Part1(cycles[0:len(cycles) - 2], []int{20, 60, 100, 140, 180, 220})
  fmt.Printf("Signal Strength: %v\n", signalStrength)

  Part2(cycles[0:len(cycles) - 2])
}
