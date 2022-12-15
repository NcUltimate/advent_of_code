package main

import (
  "io/ioutil"
  "testing"
  "strings"
)

func BenchmarkPart1(b *testing.B) {
	data, _ := ioutil.ReadFile("inputs/input.txt")
  linePairs := strings.Split(string(data), "\n\n")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    Part1(linePairs)
  }
}

func BenchmarkPart2(b *testing.B) {
	data, _ := ioutil.ReadFile("inputs/input.txt")
  linePairs := strings.Split(string(data), "\n\n")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    Part2(linePairs)
  }
}
