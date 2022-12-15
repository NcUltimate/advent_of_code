package main

import (
  "strconv"
)

func Array(input string) []any {
  ary, _ := array(input, 1);
  return ary
}

func array(input string, start int) ([]any, int) {
  idx := start
  ary := []any{}
  for idx < len(input) {
    if input[idx] == '[' {
      subArray, resultLen := array(input, idx + 1)
      idx += resultLen
      ary = append(ary, subArray)
    } else if input[idx] == ']' {
      idx += 2
      break
    } else if input[idx] == ',' {
      idx += 1
    } else {
      num := idx
      for input[num] >= '0' && input[num] <= '9' {
        num += 1
      }
      intVal, _ := strconv.Atoi(input[idx:num])
      ary = append(ary, intVal)
      idx = num
    }
  }
  return ary, idx - start 
}
