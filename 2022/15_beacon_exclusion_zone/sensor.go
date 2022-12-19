package main

import (
  "fmt"
  "strconv"
  "strings"
)

var id byte = 33

type Sensor struct {
  id                      byte
  sc, sr ,bc ,br          int
  rmag, cmag              int
  maxr, maxc, minr, minc  int
}

func (s Sensor) Dist() int {
  return s.rmag + s.cmag
}

func (s Sensor) ScanArea() int {
  return (s.rmag + 1) * (s.cmag + 1)
}

func (s Sensor) IntersectsRow(row int) bool {
  return Abs(row - s.sr) <= s.Dist()
}

func (s Sensor) Slice(row int) (int, int) {
  if !s.IntersectsRow(row) {
    return -1, -1
  }

  dSensor := Abs(row - s.sr)
  sliceStart := s.minc + dSensor
  sliceEnd := s.maxc - dSensor

  return sliceStart, sliceEnd
}

func (s Sensor) RowSegIntersection(row, colStart, colEnd int) (int, int) {
  if !s.IntersectsRow(row) || colStart > colEnd {
    return -1, -1
  }

  sStart, sEnd := s.Slice(row)

  overlapStart := Max(sStart, colStart)
  overlapEnd := Min(sEnd, colEnd)

  if overlapEnd < overlapStart {
    return -1, -1
  }

  return overlapStart, overlapEnd
}

func (s Sensor) RowIntersection(row int) int {
  if !s.IntersectsRow(row) {
    return 0
  }

  return 2 * (s.Dist() - Abs(row - s.sr)) + 1
}

func (s Sensor) Intersects(row, col int) bool {
  return Abs(row - s.sr) + Abs(col - s.sc) <= s.Dist()
}

func (s Sensor) At(row, col int) byte {
  if row == s.sr && col == s.sc {
    return 'S'
  } else if row == s.br && col == s.bc {
    return 'B'
  } else if s.Intersects(row, col) {
    return s.id
  }

  return 0
}

func (s Sensor) Print() {
  fmt.Printf("=== Sensor %v [%v, %v] ===\n", string([]byte{s.id}), s.sr, s.sc)
  fmt.Printf("Beacon at: [%v, %v]\n", s.br, s.bc)
  fmt.Printf("area=%v dist=%v\n", s.ScanArea(), s.Dist())
  fmt.Printf("minc=%v maxc=%v minr=%v maxr=%v\n", s.minc, s.maxc, s.minr, s.maxr)
  fmt.Println()
}

func NewSensor(sensorData string) (sensor Sensor) {
  coords := strings.Split(sensorData[10:], ": closest beacon is at ")

  sensorCoord := strings.Split(coords[0], ", ")
  beaconCoord := strings.Split(coords[1], ", ")

  sensor.sc, _ = strconv.Atoi(sensorCoord[0][2:])
  sensor.sr, _ = strconv.Atoi(sensorCoord[1][2:])
  sensor.bc, _ = strconv.Atoi(beaconCoord[0][2:])
  sensor.br, _ = strconv.Atoi(beaconCoord[1][2:])

  sensor.rmag = Abs(sensor.br - sensor.sr)
  sensor.cmag = Abs(sensor.bc - sensor.sc)

  sensor.minc = sensor.sc - sensor.Dist()
  sensor.minr = sensor.sr - sensor.Dist()
  sensor.maxc = sensor.sc + sensor.Dist()
  sensor.maxr = sensor.sr + sensor.Dist()

  sensor.id = id

  id += 1
  return
}
