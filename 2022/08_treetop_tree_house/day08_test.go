package main

import (
	"io/ioutil"
  "testing"
)

func getInput() [][]int {
	data, _ := ioutil.ReadFile("input.txt")
  return Forester(string(data))
}

func BenchmarkDay08Part1(b *testing.B) {
  input := getInput()
  b.ResetTimer()
  for k:=0; k < b.N; k++ {
    Part1(input)
  }
}

func BenchmarkDay08Part2(b *testing.B) {
  input := getInput()
  b.ResetTimer()
  for k:=0; k < b.N; k++ {
    Part2(input)
  }
}
