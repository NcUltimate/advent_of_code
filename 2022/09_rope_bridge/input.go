package main

import (
  "strings"
  "strconv"
)

func Input(data string) [][]int {
  inst := strings.Split(data, "\n")
  intInst := make([][]int, len(inst) - 1)

  for i := 0; i < len(inst); i++ {
    if len(inst[i]) == 0 {
      continue
    }

    mag, _ := strconv.Atoi(inst[i][2:])
    intInst[i] = []int{int(inst[i][0]), mag}
  }

  return intInst
}
