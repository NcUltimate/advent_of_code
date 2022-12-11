package main

import (
  "strings"
)

type KeepAway struct {
  monkeys      []*Monkey
  ignoreRelief bool
}

func (k KeepAway) Print() {
  for _, monkey := range k.monkeys {
    monkey.Print()
  }
}

func (k *KeepAway) run(rounds int) {
  for r := 0; r < rounds; r++ {
    for _, monkey := range k.monkeys {
      for monkey.hasItems() {
        item, recipient, err := monkey.toss()
        if err != nil {
          break
        }

        if recipient {
          k.monkeys[monkey.ifTrue].catch(item)
        } else {
          k.monkeys[monkey.ifFalse].catch(item)
        }
      }
    }
  }
}

func NewKeepAway(data string, ignoreRelief bool) (keep KeepAway) {
  monkeyData := strings.Split(string(data), "\n\n")

  keep.monkeys = make([]*Monkey, len(monkeyData))
  keep.ignoreRelief = ignoreRelief

  for i, monkeyDatum := range monkeyData {
    monkey := NewMonkey(monkeyDatum)
    monkey.ignoresRelief = ignoreRelief
    keep.monkeys[i] = &monkey
  }

  return
}
