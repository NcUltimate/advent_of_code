package main

// You don't have climbing gear, but can take
// a mighty fall...
func SlowAscByteCmp(a, b byte) bool {
  if a == 'S' {
    return (b == 'a' || b == 'b')
  }

  if b == 'E' {
    return (a == 'y' || a == 'z')
  }

  if a >= b {
    return true
  } else {
    return b - a == 1
  }
}

// You will surely perish if you fall too far,
// but you have spring boots...
func SlowDescByteCmp(a, b byte) bool {
  if b == 'S' {
    return (a == 'a' || a == 'b')
  }

  if a == 'E' {
    return (b == 'y' || b == 'z')
  }

  if b >= a {
    return true
  } else {
    return a - b == 1
  }
}
