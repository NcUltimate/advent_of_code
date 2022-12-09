package main

import (
  "io/ioutil"
  "testing"
)


func benchmark(file string, length int, b *testing.B) {
	data, _ := ioutil.ReadFile(file)
  input := Input(string(data))
  b.ResetTimer()

  for i := 0 ; i < b.N; i ++ {
    Day09(input, length, false)
  }
}

func BenchmarkDay09_Input(b *testing.B) {
  benchmark("input.txt", 9, b)
}

func BenchmarkDay09_10000(b *testing.B) {
  benchmark("10000.txt", 9, b)
}
