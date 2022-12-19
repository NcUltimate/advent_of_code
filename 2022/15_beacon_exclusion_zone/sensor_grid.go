package main

import (
  "fmt"
  "math"
  "sort"
  "strings"
)

type SensorGrid struct {
  sensors     []Sensor
  maxr, minr  int
  maxc, minc  int
}

func (g SensorGrid) Rows() int {
  return g.maxr - g.minr + 1
}

func (g SensorGrid) Cols() int {
  return g.maxc - g.minc + 1
}

func (g *SensorGrid) FindEmpty(maxCoord int) (int, int, int) {
  sort.Slice(g.sensors, func(s1, s2 int) bool {
    return g.sensors[s1].sc < g.sensors[s2].sc
  })

  min := Min(maxCoord, g.maxr)
  for row := 0; row <= min; row++ {
    end := -1

    for s := range g.sensors {
      iEnd, sEnd := g.sensors[s].RowSegIntersection(row, 0, end + 1)
      if iEnd == -1 {
        continue
      } else if sEnd > end {
        end = sEnd 
      }
    }

    if end == -1 {
      return row, 0, row
    } else if end < maxCoord {
      return row, end + 1, row + (end + 1) * 4000000
    }
  }

  return -1, -1, -1
}

func (g *SensorGrid) Scan(row int) int {
  exclusionCount := 0
  sidx := 0
  for col := g.minc; col <= g.maxc; col++ {
    checkedSensorCount := 0
    sLen := len(g.sensors)
    for checkedSensorCount < sLen {
      checkedSensorCount += 1

      for g.sensors[sidx].Excludes(row, col) {
        checkedSensorCount = 0
        exclusionCount += 1
        col += 1
      }

      sidx += 1
      sidx %= sLen
    }
  }

  return exclusionCount
}

func (g SensorGrid) Print(row int) {
  g.PrintBounds(row, Min(g.minr, g.minc), Max(g.maxr, g.maxc))
}

func (g SensorGrid) PrintBounds(row, minCoord, maxCoord int) {
  for r := minCoord; r <= Min(g.maxr, maxCoord); r++ {
    if r == row {
      fmt.Printf(">") 
    } else {
      fmt.Printf(" ")
    }

    for c := minCoord; c <= maxCoord; c++ {
      var intersects byte = 0
      for _, s := range g.sensors {
        at := s.At(r, c)
        if at != 0 {
          intersects = at
          if at == 'S' || at == 'B' {
            break
          }
        }
      }

      if intersects == 0 {
        fmt.Printf(" ")
      } else {
        fmt.Printf("%v", string([]byte{intersects}))
      }
    }

    if r == row {
      fmt.Printf("<") 
    } else {
      fmt.Printf(" ")
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

    g.maxc = Max(g.sensors[i].maxc, g.maxc)
    g.minc = Min(g.sensors[i].minc, g.minc)
    g.maxr = Max(g.sensors[i].maxr, g.maxr)
    g.minr = Min(g.sensors[i].minr, g.minr)
  }


  return
}
