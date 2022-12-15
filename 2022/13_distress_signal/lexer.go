package main

import (
//  "fmt"
  "strconv"
)

type IntToken struct {
  value int
  depth int
  index int
}

type Lexer struct {
  input     string
  pos       int
  depth     int
  indices   []int
  buffered  bool
  buffer    *IntToken
}

func (l *Lexer) Buffer() {
  if !l.buffered {
    l.buffer = l.seekInt()
    l.buffered = true
  }
}

func (l *Lexer) HasNext() bool {
  l.Buffer()
  return l.buffer != nil
}

func (l *Lexer) Next() *IntToken {
  l.Buffer()
  l.buffered = false
  return l.buffer
}

func (l *Lexer) seekInt() (token *IntToken) {
  intStart := -1
  endedArray := false
  doneScanning := false

  for l.pos < len(l.input) && !doneScanning {
    endedArray = false
    if l.input[l.pos] == '[' {
      if l.depth > -1 {
        l.indices[l.depth] += 1
      }

      l.depth += 1

      if l.depth == len(l.indices) {
        l.indices = append(l.indices, -1)
      } else {
        l.indices[l.depth] = -1
      }
    } else if l.input[l.pos] == ']' {
      if intStart != -1 || l.input[l.pos-1] == '['{
        intStart = 0
        doneScanning = true
      }
      l.indices[l.depth] += 1
      l.depth -= 1
      endedArray = true
    } else if l.input[l.pos] >= '0' && l.input[l.pos] <= '9' {
      if intStart == -1 {
        intStart = l.pos
      }
    } else if l.input[l.pos] == ',' {
      if intStart != -1 {
        doneScanning = true
        l.indices[l.depth] += 1
      }
    }
    l.pos += 1
  }

  if intStart != -1 {
    depth := l.depth
    if endedArray {
      depth += 1
    }
    
    var intVal int
    if l.input[l.pos-2] == '[' {
      intVal = -1
    } else {
      intVal, _ = strconv.Atoi(l.input[intStart:l.pos - 1])
    }

    token = &IntToken{
      value: intVal,
      depth: depth,
      index: l.indices[depth],
    }
  }

  return
}

func NewLexer(input string) (l Lexer) {
  l.input = input
  l.depth = -1
  l.indices = make([]int, 0)
  return
}
