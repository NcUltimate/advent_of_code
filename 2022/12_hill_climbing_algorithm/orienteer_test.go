package main

import (
  "io/ioutil"
  "testing"
)

func BenchmarkTraverseWithInit(b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    orienteer := NewOrienteer(string(data))
    orienteer.Traverse()
  }
}

func BenchmarkTraverseToE(b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    orienteer := NewOrienteer(string(data))
    b.StartTimer()
    orienteer.Traverse()
  }
}

func BenchmarkTreverseToA(b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    orienteer := NewOrienteer(string(data))
    b.StartTimer()
    orienteer.TreverseTo('a')
  }
}
