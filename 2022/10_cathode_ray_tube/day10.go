package main

import (
  "fmt"
  "strconv"
)

func UpdateCycleSum(cycleSum *int, allSum int, nextIdx *int, cycle int, cycles []int) bool {
  if cycles[*nextIdx] == cycle {
    *cycleSum += cycle * allSum
    *nextIdx += 1
  }

  return *nextIdx == len(cycles)
}

func Part1(instructions []string, cycles []int) int {
  allSum := 1
  cycleSum := 0
  cycleIdx := 0
  nextCycleIdx := 0

  for _, instr := range instructions {
    cycleIdx += 1
    if UpdateCycleSum(&cycleSum, allSum, &nextCycleIdx, cycleIdx + 1, cycles) {
      return cycleSum
    }

    if instr[0] == 110 { // n
      // NOOP
    } else if instr[0] == 97 { // a
      cycleIdx += 1
      num, _ := strconv.Atoi(instr[5:])
      allSum += num

      if UpdateCycleSum(&cycleSum, allSum, &nextCycleIdx, cycleIdx + 1, cycles) {
        return cycleSum
      }
    }
  }

  return cycleSum
}

const (
  CRTW = 40
  CRTH = 6
)

func UpdateCRT(crt [][]bool, cycle, spritePos int) {
  pixH := cycle % CRTW
  if pixH >= spritePos - 1 && pixH <= spritePos + 1 {
    pixV := cycle / CRTW
    crt[pixV][pixH] = true
  }
}

func Part2(instructions []string) {
  spritePos := 1

  crt := make([][]bool, CRTH)
  for i := 0; i < CRTH; i++ {
    crt[i] = make([]bool, CRTW)
  }

  cycle := 0

  for _, instr := range instructions {
    UpdateCRT(crt, cycle, spritePos)
    cycle += 1

    if instr[0] == 110 { // n
      // NOOP
    } else if instr[0] == 97 { // a
      UpdateCRT(crt, cycle, spritePos)
      cycle += 1

      posUpdate, _ := strconv.Atoi(instr[5:])
      spritePos += posUpdate
    }
  }

  for i := 0; i < CRTH; i++ {
    for j := 0; j < CRTW; j++ {
      if crt[i][j] {
        fmt.Printf("@")
      } else {
        fmt.Printf(" ")
      }
    }
    fmt.Println()
  }
}
