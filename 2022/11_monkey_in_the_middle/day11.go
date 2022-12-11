package main

import (
  "fmt"
  "sort"
)

func Part1(data string) {
  keepAway := NewKeepAway(data, false)
  keepAway.run(20)

  sort.Slice(keepAway.monkeys, func(a,b int) bool {
    return keepAway.monkeys[b].inspections < keepAway.monkeys[a].inspections
  })

  keepAway.Print()

  result := keepAway.monkeys[0].inspections * keepAway.monkeys[1].inspections
  fmt.Printf("Monkey Business: %v\n", result)
}

func Part2(data string) {
  keepAway := NewKeepAway(data, true)
  keepAway.run(9000)

  sort.Slice(keepAway.monkeys, func(a,b int) bool {
    return keepAway.monkeys[b].inspections < keepAway.monkeys[a].inspections
  })

  keepAway.Print()

  result := keepAway.monkeys[0].inspections * keepAway.monkeys[1].inspections
  fmt.Printf("Monkey Business: %v\n", result)
}
