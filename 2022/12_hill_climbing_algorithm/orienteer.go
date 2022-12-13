package main

import (
  "fmt"
  "math"
  "strings"
)

type Orienteer struct {
  hmap        [][]byte
  lmap        [][]int
  visited     [][]bool
  parent      [][][]int

  // Grid boundaries
  nC, nR      int

  // Starting coordinate
  sC, sR      int

  // Ending coordinate
  eC, eR      int

  // Shortest path
  shortest    int
}

func (o *Orienteer) Traverse() {
  o.traverseBFS(false, 'E')
}

// Get it ... 🥁
func (o *Orienteer) Treverse() {
  o.traverseBFS(true, 'S')
}

func (o *Orienteer) TreverseTo(target byte) {
  o.traverseBFS(true, target)
}

func (o *Orienteer) traverseBFS(desc bool, target byte) {
  tsR, tsC := o.sR, o.sC
  if desc {
    tsR, tsC = o.eR, o.eC
  }

  rQ := make([]int, 0, o.nR * o.nC)
  cQ := make([]int, 0, o.nR * o.nC)

  rQ = append(rQ, tsR)
  cQ = append(cQ, tsC)

  o.visited[tsR][tsC] = true
  o.lmap[tsR][tsC] = 0

  for qHead := 0; qHead < len(rQ); qHead++ {
    nr, nc := rQ[qHead], cQ[qHead]

    coords := [][]int {
      { nr - 1, nc },
      { nr + 1, nc },
      { nr, nc - 1 },
      { nr, nc + 1 },
    };

    for _, x := range coords {
      if x[0] < 0 || x[0] >= o.nR || x[1] < 0 || x[1] >= o.nC {
        continue
      }

      if o.visited[x[0]][x[1]] {
        continue
      }
      
      cmp := SlowAscByteCmp
      if desc {
        cmp = SlowDescByteCmp
      }

      if cmp(o.hmap[nr][nc], o.hmap[x[0]][x[1]]) {
        rQ = append(rQ, x[0])
        cQ = append(cQ, x[1])
        o.parent[x[0]][x[1]] = []int{nr, nc}
        o.visited[x[0]][x[1]] = true
        o.lmap[x[0]][x[1]] = o.lmap[nr][nc] + 1
      }
    }
  }

  min := math.MaxInt
  for r := 0; r < o.nR; r++ {
    for c := 0; c < o.nC; c++ {
      if o.hmap[r][c] == target && o.lmap[r][c] != 0 {
        if o.lmap[r][c] < min {
          min = o.lmap[r][c] 
        }
      }
    }
  }

  o.shortest = min
}

func (o Orienteer) PrintLMap() {
  for i := range o.lmap {
    for j := range o.lmap[i] {
      if o.lmap[i][j] == 0 {
        fmt.Printf(" ")
      } else {
        fmt.Printf("%s", string([]byte{byte(o.lmap[i][j] % 26 + 97)}))
      }
    }
    fmt.Println()
  }
}

func (o Orienteer) PrintHMap() {
  for i := range o.hmap {
    for j := range o.hmap[i] {
      fmt.Printf("%s", string([]byte{o.hmap[i][j]}))
    }
    fmt.Println()
  }
}

func (o Orienteer) PrintShortest() {
  fmt.Printf("Shortest Path: %v\n", o.shortest)
}

func (o Orienteer) Print() {
  o.PrintHMap()
  o.PrintLMap()
  o.PrintShortest()
}

func NewOrienteer(mapData string) (o Orienteer) {
  rows := strings.Split(string(mapData), "\n")
  o.nR = len(rows) - 1
  o.nC = len(rows[0])

  o.hmap = make([][]byte, o.nR)
  o.lmap = make([][]int, o.nR)
  o.visited = make([][]bool, o.nR)
  o.parent = make([][][]int, o.nR)
  o.shortest = math.MaxInt

  for i := range o.hmap {
    o.visited[i] = make([]bool, o.nC)
    o.parent[i] = make([][]int, o.nC)

    o.hmap[i] = make([]byte, o.nC)
    o.lmap[i] = make([]int, o.nC)
    for j := range o.hmap[i] {
      o.parent[i][j] = []int{i, j}
      o.hmap[i][j] = rows[i][j]
      o.lmap[i][j] = 0

      if rows[i][j] == 'S' {
        o.sR, o.sC = i, j
      }

      if rows[i][j] == 'E' {
        o.eR, o.eC = i, j
      }
    }
  }

  return
}
