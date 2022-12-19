package main

import (
  "math"
)

func Abs(a int) int {
  if a < 0 {
    return -a
  }
  return a
}

func Min(nums ...int) int {
  min := math.MaxInt
  for _, n := range nums {
    if n < min {
      min = n
    }
  }
  return min
}

func Max(nums ...int) int {
  max := 0
  for _, n := range nums {
    if n > max {
      max = n
    }
  }
  return max
}
