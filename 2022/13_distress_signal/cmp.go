package main

import (
  "reflect"
)

func ArrayCmp(left, right []any) int {
  l, r := 0, 0
  for l < len(left) || r < len(right) {
    if r < len(right) && l == len(left) {
      return -1
    } else if r == len(right) && l < len(left) {
      return 1
    }

    ltype := reflect.TypeOf(left[l]).Kind()
    rtype := reflect.TypeOf(right[r]).Kind()

    var result int
    if ltype == reflect.Slice && rtype == reflect.Slice {
      result = ArrayCmp(left[l].([]any), right[r].([]any))
    } else if ltype == reflect.Slice && rtype == reflect.Int {
      result = ArrayCmp(left[l].([]any), []any{right[r]})
    } else if ltype == reflect.Int && rtype == reflect.Slice {
      result = ArrayCmp([]any{left[l]}, right[r].([]any))
    } else if ltype == reflect.Int && rtype == reflect.Int {
      if left[l].(int) < right[r].(int) {
        result = -1
      } else if right[r].(int) < left[l].(int) {
        result = 1
      } else {
        result = 0
      }
    }

    if result != 0 {
      return result
    }

    l += 1
    r += 1
  }

  return 0
}
