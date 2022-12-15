package main

import (
  "fmt"
  "strings"
)

type Part1 struct {
  parser Parser
  index  int
}

func (p Part1) IsOrdered() bool {
  return p.parser.isOrdered
}

func NewPart1(index int, linePair string) (p Part1) {
  pair := strings.Split(linePair, "\n")
  p.index = index
  p.parser = NewParser(pair)
  p.parser.Parse()
  return
}

func Day13(input string) {
  linePairs := strings.Split(input, "\n\n")

  idxSum := 0
  for idx, linePair := range linePairs {
    part1 := NewPart1(idx, linePair)
    if part1.IsOrdered() {
      idxSum += idx+1
    }
  }

  fmt.Printf("Index Sum of Pairs: %v\n", idxSum)
}
