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

  orienteer := NewOrienteer(string(data))
  orienteer.PrintHMap()
  fmt.Println()

  orienteer.Traverse()
  orienteer.PrintLMap()
  orienteer.PrintShortest()

  fmt.Println()

  orienteer = NewOrienteer(string(data))
  orienteer.TreverseTo('a')
  orienteer.PrintLMap()
  orienteer.PrintShortest()
}
