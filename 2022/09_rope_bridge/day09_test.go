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

func BenchmarkDay09_Input_9(b *testing.B) {
  benchmark("input/input.txt", 9, b)
}

func BenchmarkDay09_Input_90(b *testing.B) {
  benchmark("input/input.txt", 90, b)
}

func BenchmarkDay09_Input_900(b *testing.B) {
  benchmark("input/input.txt", 900, b)
}

func BenchmarkDay09_Input_9000(b *testing.B) {
  benchmark("input/input.txt", 9000, b)
}

func BenchmarkDay09_Input_90000(b *testing.B) {
  benchmark("input/input.txt", 90000, b)
}
