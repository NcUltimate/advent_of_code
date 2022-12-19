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

	rowNumStr := os.Args[2]
  rowNum, _ := strconv.Atoi(rowNumStr)

  sensorGrid := NewSensorGrid(string(data))
  sensorGrid.Print()
  sensorGrid.Scan()
  sensorGrid.Print()

  exclusions := sensorGrid.CountExclusions(rowNum)
  fmt.Printf("Row %v has %v exclusions\n", rowNum, exclusions)
}
