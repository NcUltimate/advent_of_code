package main

import (
  "strings"
  "strconv"
)

func Forester(treeData string) [][]int {
  input := strings.Split(string(treeData), "\n")
  forest := make([][]int, len(input) - 1)

  for i, _ := range input {
    if(len(input[i]) == 0) {
      continue
    }

    inputRow := strings.Split(input[i], "")
    forestRow := make([]int, len(inputRow))

    for j, tree := range inputRow {
      forestRow[j], _ = strconv.Atoi(tree)   
    }

    forest[i] = forestRow
  }

  return forest
}
