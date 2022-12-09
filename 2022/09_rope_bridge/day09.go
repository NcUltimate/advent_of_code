package main

import (
  "fmt"
  "strconv"
)

const (
  D = 68
  L = 76
  R = 82
  U = 85
  X = 0
  Y = 1
)

func GetTailMove(tail []int, head []int) []int {
  result := []int{0, 0}

  if head[Y] == tail[Y] + 2 {
    result[Y] = 1
    if head[X] > tail[X] {
      result[X] = 1
    }
    if head[X] < tail[X] {
      result[X] = -1
    }
  }

  if head[X] == tail[X] + 2 {
    result[X] = 1
    if head[Y] > tail[Y] {
      result[Y] = 1
    }
    if head[Y] < tail[Y] {
      result[Y] = -1
    }
  }

  if head[Y] == tail[Y] - 2 {
    result[Y] = -1
    if head[X] > tail[X] {
      result[X] = 1
    }
    if head[X] < tail[X] {
      result[X] = -1
    }
  }

  if head[X] == tail[X] - 2 {
    result[X] = -1
    if head[Y] > tail[Y] {
      result[Y] = 1
    }
    if head[Y] < tail[Y] {
      result[Y] = -1
    }
  }

  return result
}

func Visit(visited map[int]map[int]bool, x int, y int) int {
  if _, ok := visited[x]; !ok {
    visited[x] = make(map[int]bool)
  }

  if _, ok := visited[x][y]; !ok {
    visited[x][y] = true
    return 1
  }

  return 0
}

func PrintRope(xb []int, yb []int, head []int, tail [][]int, visited map[int]map[int]bool) {
  for y := yb[1]; y >= yb[0]; y-- {
    for x := xb[0]; x <= xb[1]; x++ {
      isT := false
      for i, t := range tail {
        if t[X] == x && t[Y] == y {
          fmt.Printf("%v", i + 1)
          isT = true
          break
        }
      }

      if isT == true {
        continue
      }

      if head[X] == x && head[Y] == y {
        fmt.Printf("H")
        continue
      }

      if visited[x][y] {
        fmt.Printf("@")
      } else {
        fmt.Printf(".")
      }
    }
    fmt.Println()
  }
}

func Day09(instructions []string, tailLen int, visualize bool) int {
  head := []int{0, 0}
  tail := make([][]int, tailLen)
  for i := 0; i < tailLen; i++ {
    tail[i] = []int{0, 0};
  }

  xb := []int{0, 0}
  yb := []int{0, 0}

  uniqueVisits := 0

  visited := make(map[int]map[int]bool)
  uniqueVisits += Visit(visited, 0, 0)

  for _, inst := range instructions {
    if len(inst) == 0 {
      continue
    }

    mag, _ := strconv.Atoi(inst[2:])
    for i := 0; i < mag; i++ {
      if inst[0] == D {
        head[Y] -= 1
        if head[Y] < yb[0] {
          yb[0] = head[Y]
        }
      }

      if inst[0] == L {
        head[X] -= 1
        if head[X] < xb[0] {
          xb[0] = head[X]
        }
      }

      if inst[0] == R {
        head[X] += 1
        if head[X] > xb[1] {
          xb[1] = head[X]
        }
      }

      if inst[0] == U {
        head[Y] += 1
        if head[Y] > yb[1] {
          yb[1] = head[Y]
        }
      }

      for t := 0; t < tailLen; t++ {
        var vec []int
        if t == 0 {
          vec = GetTailMove(tail[t], head)
        } else {
          vec = GetTailMove(tail[t], tail[t-1])
        }

        tail[t][X] += vec[X]
        tail[t][Y] += vec[Y]
      }

      uniqueVisits += Visit(visited, tail[tailLen - 1][X], tail[tailLen - 1][Y])
    }
  }

  if visualize {
    PrintRope(xb, yb, head, tail, visited)
    fmt.Println()
  }

  return uniqueVisits
}
