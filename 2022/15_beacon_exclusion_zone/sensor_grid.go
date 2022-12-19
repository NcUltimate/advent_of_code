package main

import (
  "fmt"
  "math"
  "strings"
)

type SensorGrid struct {
  sensors     []Sensor
  grid        [][]byte
  maxr, minr  int
  maxc, minc  int
}

func (g SensorGrid) Rows() int {
  return g.maxr - g.minr + 1
}

func (g SensorGrid) Cols() int {
  return g.maxc - g.minc + 1
}

func (g SensorGrid) Get(r, c int) byte {
  if !g.Contains(r, c) {
    return 0
  }

  return g.grid[r - g.minr][c - g.minc]
}

func (g SensorGrid) CanPut(b byte, r, c int) bool {
  atRc := g.Get(r, c)
  return atRc == ' ' || (atRc != b && atRc != 'S' && atRc != 'B')
}

func (g *SensorGrid) Put(b byte, r, c int) {
  g.grid[r - g.minr][c - g.minc] = b
}

func (g SensorGrid) Contains(r, c int) bool {
  return r >= g.minr && r <= g.maxr && c >= g.minc && c <= g.maxc
}

func (g *SensorGrid) Scan() {
  for i := range g.sensors {
    s := g.sensors[i]

    qr := make([]int, 0, s.ScanArea())
    qc := make([]int, 0, s.ScanArea())
    qd := make([]int, 0, s.ScanArea())

    qr = append(qr, s.sr)
    qc = append(qc, s.sc)
    qd = append(qd, 0)

    for qhead := 0; qhead < len(qr); qhead++ {
      r, c, d := qr[qhead], qc[qhead], qd[qhead]

      var neighbs = [][]int{
        { r + 1, c },
        { r - 1, c },
        { r, c + 1 },
        { r, c - 1 },
      };

      for n := range neighbs {
        nr, nc := neighbs[n][0], neighbs[n][1]
        if !g.Contains(nr, nc) {
          continue
        }

        if !g.CanPut(s.id, nr, nc) {
          continue
        }

        if d + 1 > s.Dist() {
          continue
        }

        qr = append(qr, nr)
        qc = append(qc, nc)
        qd = append(qd, d + 1)
        g.Put(s.id, nr, nc)
      }
    }
  }
}

func (s *SensorGrid) CountExclusions(row int) int {
  if !s.Contains(row, s.minc) {
    return 0
  }

  count := 0
  for col := s.minc; col < s.maxc; col++ {
    if s.Get(row, col) != 'B' && s.Get(row, col) != ' ' {
      count += 1
    }
  }

  return count
}

func (g SensorGrid) Print() {
  for r := range g.grid {
    for c := range g.grid[r] {
      fmt.Printf("%v", string([]byte{g.grid[r][c]}))
    }
    fmt.Println()
  }
  fmt.Println()
}

func NewSensorGrid(data string) (g SensorGrid) {
  g.minr, g.maxr, g.minc, g.maxc = math.MaxInt, 0, math.MaxInt, 0

  sensorData := strings.Split(data, "\n")
  g.sensors = make([]Sensor, len(sensorData) - 1)
  for i, sensorDatum := range sensorData {
    if len(sensorDatum) == 0 {
      continue
    }
    g.sensors[i] = NewSensor(sensorDatum)

    if g.sensors[i].sc > g.maxc {
      g.maxc = g.sensors[i].sc
    }
    if g.sensors[i].sc < g.minc {
      g.minc = g.sensors[i].sc
    }
    if g.sensors[i].bc > g.maxc {
      g.maxc = g.sensors[i].bc
    }
    if g.sensors[i].bc < g.minc {
      g.minc = g.sensors[i].bc
    }
    if g.sensors[i].sr > g.maxr {
      g.maxr = g.sensors[i].sr
    }
    if g.sensors[i].sr < g.minr {
      g.minr = g.sensors[i].sr
    }
    if g.sensors[i].br > g.maxr {
      g.maxr = g.sensors[i].br
    }
    if g.sensors[i].br < g.minr {
      g.minr = g.sensors[i].br
    }
  }

  fmt.Printf("Making a %v x %v grid\n", g.Rows(), g.Cols())

  g.grid = make([][]byte, g.Rows())
  for r := 0; r < g.Rows(); r++ {
    g.grid[r] = make([]byte, g.Cols())
    for c := 0; c < g.Cols(); c++ {
      g.grid[r][c] = ' '
    }
  }

  fmt.Printf("Grid is %v x %v\n", g.Rows(), g.Cols())

  for s := range g.sensors {
    g.sensors[s].Print()
    g.Put('S', g.sensors[s].sr, g.sensors[s].sc)
    g.Put('B', g.sensors[s].br, g.sensors[s].bc)
  }

  return
}
