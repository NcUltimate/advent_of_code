package main

import (
  "io/ioutil"
  "testing"
)

func BenchmarkPart1(b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    cave := NewCave(string(data), true)
    b.StartTimer()
    cave.DripSand()
  }
}

func BenchmarkPart2(b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    cave := NewCave(string(data), false)
    b.StartTimer()
    cave.DripSand()
  }
}
