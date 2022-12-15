package main

import (
  "io/ioutil"
  "testing"
)

func benchmark(dfs bool, infinite bool, b *testing.B) {
	data, _ := ioutil.ReadFile("input.txt")
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    b.StopTimer()
    cave := NewCave(string(data), infinite)
    b.StartTimer()

    cave.DrawPaths()
    if dfs {
      cave.PourSand()
    } else {
      cave.DripSand()
    }
  }
}

func BenchmarkPart1_GrainByGrain_Infinite(b *testing.B) {
  benchmark(false, true, b)
}

func BenchmarkPart1_GrainByGrain_Floored(b *testing.B) {
  benchmark(false, false, b)
}

func BenchmarkPart1_DFS_Infinite(b *testing.B) {
  benchmark(true, true, b)
}

func BenchmarkPart1_DFS_Floored(b *testing.B) {
  benchmark(true, false, b)
}
