package main


import (
	"io/ioutil"
  "strings"
  "testing"
)

func getInput() []string {
	data, _ := ioutil.ReadFile("input.txt")
  return strings.Split(string(data), "\n")
}

func BenchmarkDay07(b *testing.B) {
  input := getInput();
  b.ResetTimer()
  for k:=0; k < b.N; k++ {
    Day07(input)
  }
}
