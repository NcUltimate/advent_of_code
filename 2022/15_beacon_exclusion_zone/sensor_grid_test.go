package main

import (
  "io/ioutil"
  "testing"
)

func BenchmarkPart1(b *testing.B) {
	data, _ := ioutil.ReadFile("inputs/input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    sensorGrid := NewSensorGrid(string(data))
    b.StartTimer()

    sensorGrid.Scan(2000000)
  }
}

func BenchmarkPart2(b *testing.B) {
	data, _ := ioutil.ReadFile("inputs/input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    sensorGrid := NewSensorGrid(string(data))
    b.StartTimer()

    sensorGrid.FindEmpty(4000000)
  }
}
