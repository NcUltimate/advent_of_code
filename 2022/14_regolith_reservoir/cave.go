package main

import (
  "fmt"
  "strings"
  "strconv"
)

const (
  COLS = 1040
  ROWS = 170
)

type Cave struct {
  grid                    [][]byte
  input                   string
  infinite                bool
  didCount                bool
  restingCount            int
  minR, minC, maxR, maxC  int
}

func (c Cave) Print() {
  for row := c.minR; row <= c.maxR; row++ {
    for col := c.minC; col <= c.maxC; col++ {
      if c.grid[row][col] != 0 {
        fmt.Printf("%s", string([]byte{c.grid[row][col]}))
      } else {
        fmt.Printf(".")
      }
    }
    fmt.Println()
  }

  fmt.Printf("Resting: %v\n", c.restingCount)
}

func (cave *Cave) DrawPaths() {
  if cave.didCount {
    return
  }

  for _, path := range strings.Split(cave.input, "\n") {
    if len(path) == 0 {
      continue
    }

    col, row := -1, -1
    for _, segment := range strings.Split(path, " -> ")  {
      coord := strings.Split(segment, ",")
      c, _ := strconv.Atoi(coord[0])
      r, _ := strconv.Atoi(coord[1])
      if r > cave.maxR {
        cave.maxR = r
      }
      if c > cave.maxC {
        cave.maxC = c
      }

      if col == -1 {
        col = c
        row = r
        continue
      }

      for col > c {
        cave.grid[row][col] = '#'
        col -= 1
      }

      for col < c {
        cave.grid[row][col] = '#'
        col += 1
      }

      for row > r {
        cave.grid[row][col] = '#'
        row -= 1
      }

      for row < r {
        cave.grid[row][col] = '#'
        row += 1
      }
      cave.grid[row][col] = '#'
    }
  }

  if !cave.infinite {
    cave.maxR += 2
    for c := range cave.grid[cave.maxR] {
      cave.grid[cave.maxR][c] = '#'
    }
  }
}

func (cave *Cave) DripSand() {
  lC, lR := COLS, ROWS
  gC, gR := 500, 0
  for lR > 0 && lC > 0 && gC < COLS - 1 && gR < ROWS - 1 {
    if cave.grid[gR+1][gC] == 0 {
      gR += 1
    } else if cave.grid[gR+1][gC-1] == 0 {
      gR += 1
      gC -= 1
    } else if cave.grid[gR+1][gC+1] == 0 {
      gR += 1
      gC += 1
    } else {
      cave.grid[gR][gC] = 'o'
      cave.restingCount += 1
      lC, lR = gC, gR
      gC, gR = 500, 0
    }

    if gR < cave.minR {
      cave.minR = gR
    }
    if gC < cave.minC {
      cave.minC = gC
    }
    if gC > cave.maxC {
      cave.maxC = gC
    }
  }
}

func (cave *Cave) PourSand() {
  cave.PutSand(0, 500)
}

func (cave *Cave) PutSand(r, c int) byte {
  if r < 0 || c < 0 || r > ROWS - 1 || c > COLS - 1 {
    return 3 // special byte for hitting infinity
  }

  if r < cave.minR {
    cave.minR = r
  }
  if c < cave.minC {
    cave.minC = c
  }
  if c > cave.maxC {
    cave.maxC = c
  }

  if cave.grid[r][c] != 0 {
    return cave.grid[r][c]
  }

  downResult := cave.PutSand(r+1, c)
  if downResult > 3 {

    leftResult := cave.PutSand(r+1, c-1)
    if leftResult > 3 {

      rightResult := cave.PutSand(r+1, c+1)
      if rightResult > 3 {
        cave.grid[r][c] = 'o'
        cave.restingCount += 1
        return 'o'
      }
    }
  }

  return 3
}

func NewCave(input string, infinite bool) (cave Cave) {
  cave.infinite = infinite
  cave.input = input
  cave.minC, cave.minR = COLS, ROWS

  cave.grid = make([][]byte, ROWS)
  for i := 0; i < ROWS; i++ {
    cave.grid[i] = make([]byte, COLS)
  }

  return
}
