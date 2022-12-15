package main

import "fmt"

type Parser struct {
  left      Lexer
  right     Lexer
  isDone    bool
  isOrdered bool
}

func (p *Parser) Parse() {
  var lToken, rToken *IntToken
  for !p.isDone { 
    lToken = p.left.Next()
    rToken = p.right.Next()

    fmt.Printf("%v - %v\n", lToken, rToken)

    if lToken == nil && rToken != nil{ // left ran out first
      p.isDone = true
      p.isOrdered = true
    } else if rToken == nil && lToken != nil{ // right ran out first
      p.isDone = true
      p.isOrdered = false
    } else if lToken == nil && rToken == nil { // ran out simultaneously
      p.isDone = true
      p.isOrdered = p.left.pos <= p.right.pos
    } else if lToken.value > rToken.value {
      p.isDone = true
      p.isOrdered = false
    } else if lToken.value < rToken.value {
      p.isDone = true
      p.isOrdered = true
    }
  }
  fmt.Printf("Result: [done=%v ordered=%v]\n", p.isDone, p.isOrdered)
  fmt.Println()
}

func NewParser(pair []string) (p Parser) {
  p.left = NewLexer(pair[0])
  p.right = NewLexer(pair[1])
  return
}
