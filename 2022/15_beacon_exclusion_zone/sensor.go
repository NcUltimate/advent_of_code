package main

import (
  "fmt"
  "strconv"
  "strings"
)

var id byte = 33

type Sensor struct {
  id                    byte
  sc,sr,bc,br,rmag,cmag int
}

func (s Sensor) Dist() int {
  return s.rmag + s.cmag
}

func (s Sensor) ScanArea() int {
  return (s.rmag + 1) * (s.cmag + 1)
}

func (s Sensor) At(row, col int) byte {
  if row == s.sr && col == s.sc {
    return 'S'
  } else if row == s.br && col == s.bc {
    return 'B'
  }

  return 0
}

func (s Sensor) Print() {
  fmt.Printf("=== Sensor %v [%v, %v] ===\n", s.id, s.sr, s.sc)
  fmt.Printf("Beacon at: [%v, %v]\n", s.br, s.bc)
  fmt.Printf("area=%v dist=%v\n", s.ScanArea(), s.Dist())
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

  sensor.rmag = sensor.br - sensor.sr
  if sensor.rmag < 0 {
    sensor.rmag = -sensor.rmag
  }

  sensor.cmag = sensor.bc - sensor.sc
  if sensor.cmag < 0 {
    sensor.cmag = -sensor.cmag
  }

  sensor.id = id
  id += 1

  return
}
