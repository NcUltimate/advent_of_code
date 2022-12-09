package main

import (
  "fmt"
  "io/ioutil"
  "math/rand"
  "strings"
  "testing"
)

func generateInput(scale int) []string {
  instructions := make([]string, scale)
  directions := []int{U, D, R, L}

  for i := 0; i < scale; i++ {
    direction := directions[rand.Intn(4)]  
    magnitude := rand.Intn(scale)
    instruction := fmt.Sprintf("%v %v", direction, magnitude)

    instructions = append(instructions, instruction)
  }

  return instructions
}

func benchmark(input []string, ropeLen int, b *testing.B) {
  b.ResetTimer()
  for i := 0 ; i < b.N; i ++ {
    Day09(input, ropeLen, false)
  }
}

func BenchmarkDay09Input(b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  input := strings.Split(string(data), "\n")
  benchmark(input, 9, b) 
}

func BenchmarkDay09_Scale10(b *testing.B) {
  input := generateInput(10)
  benchmark(input, 10, b) 
}

func BenchmarkDay09_Scale100(b *testing.B) {
  input := generateInput(100)
  benchmark(input, 100, b) 
}

func BenchmarkDay09_Scale1000(b *testing.B) {
  input := generateInput(1000)
  benchmark(input, 1000, b) 
}

func BenchmarkDay09_Scale10000(b *testing.B) {
  input := generateInput(10000)
  benchmark(input, 10000, b) 
}

func BenchmarkDay09_Scale100000(b *testing.B) {
  input := generateInput(100000)
  benchmark(input, 100000, b) 
}

func BenchmarkDay09_Scale1000000(b *testing.B) {
  input := generateInput(1000000)
  benchmark(input, 1000000, b) 
}
