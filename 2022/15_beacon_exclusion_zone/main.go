package main

import (
  "fmt"
	"io/ioutil"
	"os"
  "strconv"
)

func main() {
	filename := os.Args[1]
	data, ferr := ioutil.ReadFile(filename)
	if ferr != nil {
		fmt.Println("Error:", ferr)
		os.Exit(1)
	}

  sensorGrid := NewSensorGrid(string(data))

  if os.Args[2] == "part1" {
    rowNumStr := os.Args[3]
    rowNum, _ := strconv.Atoi(rowNumStr)
    exclusions := sensorGrid.Scan(rowNum)

    if len(os.Args) > 4 {
      sensorGrid.Print(rowNum)
    }

    fmt.Printf("Row %v has %v exclusions\n", rowNum, exclusions)
  } else {
    maxCoordStr := os.Args[3]
    maxCoord, _ := strconv.Atoi(maxCoordStr)
    row, col, score := sensorGrid.FindEmpty(maxCoord)

    if len(os.Args) > 4 {
      sensorGrid.PrintBounds(row, 0, maxCoord)
    }

    fmt.Printf("Distress Beacon is at [%v, %v] - tuning frequency is %v\n", row, col, score)
  }
}
