package main

import (
  "errors"
  "fmt"
  "strconv"
  "strings"
)

const (
  ADD = 43
  MUL = 42
  SUB = 45
  DIV = 47
  POW = 94
)

type Monkey struct {
  id            int
  items         []int
  itemPtr       int
  operator      byte
  operand       int
  modulo        int
  ifTrue        int
  ifFalse       int
  inspections   int
  ignoresRelief bool
}

func (m Monkey) hasItems() bool {
  return m.itemPtr > -1
}

func (m *Monkey) toss() (int, bool, error) {
  if m.itemPtr <= 0 {
    return -1, false, errors.New("No items to toss")
  }

  item := m.items[m.itemPtr - 1]
  m.itemPtr -= 1
  m.inspections += 1

  if m.operator == ADD {
    item += m.operand
  } else if m.operator == SUB {
    item -= m.operand
  } else if m.operator == MUL {
    item *= m.operand
  } else if m.operator == DIV {
    item /= m.operand
  } else {
    item *= item
  }

  if m.ignoresRelief {
    // TODO: manage growth of item size
  } else {
    item /= 3
  }

  divisible := item % m.modulo == 0
  thrown := item
  if divisible {
    thrown = 0
  }

  return thrown, divisible, nil
}

func (m *Monkey) catch(item int) {
  if m.itemPtr < len(m.items) {
    m.items[m.itemPtr] = item
    m.itemPtr += 1
  } else {
    m.items = append(m.items, item)
    m.itemPtr += 1
  }
}

func (m Monkey) Print() {
  fmt.Printf("[%v] %v %v\n", m.id, m.inspections,  m.items[:m.itemPtr])
}

func NewMonkey(monkeyDatum string) (monkey Monkey) {
  lines := strings.Split(monkeyDatum, "\n")
  for _, rawLine := range lines {
    line := strings.TrimSpace(rawLine) 
    if len(line) == 0 {
      continue
    }

    if line[0] == 83 { // S
      itemData := strings.Split(line[16:], ", ")
      monkey.items = make([]int, len(itemData))
      monkey.itemPtr = len(itemData)
      for i, item := range itemData {
         itemNum, _ := strconv.Atoi(item)
         monkey.items[i] = itemNum 
      }
    } else if line[0] == 79 { // O
      if line[23] == 111 { // o
        monkey.operator = POW
        monkey.operand = POW
      } else {
        operand, _ := strconv.Atoi(line[23:])
        monkey.operand = operand
        monkey.operator = line[21]
      }
    } else if line[0] == 84 { // T
      modulo, _ := strconv.Atoi(line[19:])
      monkey.modulo = modulo
    } else if line[3] == 116 { // t
      throwTo, _ := strconv.Atoi(line[25:])
      monkey.ifTrue = throwTo
    } else if line[3] == 102 { // f
      throwTo, _ := strconv.Atoi(line[26:])
      monkey.ifFalse = throwTo
    } else if line[0] == 77 { // M
      id, _ := strconv.Atoi(line[7:8])
      monkey.id = id
    }
  }
  return
}
