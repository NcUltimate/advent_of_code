package main

import (
  "fmt"
  "sort"
  "strings"
)

func Part1(linePairs []string) int{
  idxSum := 0
  for idx, linePair := range linePairs {
    pair := strings.Split(linePair, "\n")
    left := Array(pair[0])
    right := Array(pair[1])
    result := ArrayCmp(left, right)

    if result == -1 {
      idxSum += idx + 1
    }
  }

  return idxSum
}

type ArrayItem struct {
  id    int
  array []any
}

func Part2(linePairs []string) int {
  allPackets := make([]ArrayItem, 2*len(linePairs) + 2)
  allPackets[0] = ArrayItem{
    id: 0,
    array: Array("[[2]]"),
  }

  allPackets[1] = ArrayItem{
    id: 1,
    array: Array("[[6]]"),
  }

  packetIdx := 2
  for _, linePair := range linePairs {
    pair := strings.Split(linePair, "\n")

    allPackets[packetIdx] = ArrayItem{
      id:    packetIdx,
      array: Array(pair[0]),
    }
    packetIdx += 1

    allPackets[packetIdx] = ArrayItem{
      id:    packetIdx,
      array: Array(pair[1]),
    }
    packetIdx += 1
  }

  sort.Slice(allPackets, func(i, j int) bool {
    return ArrayCmp(allPackets[i].array, allPackets[j].array) == -1
  })

  idx2, idx6 := 0, 0
  for idx, packet := range allPackets {
    if packet.id == 0 {
      idx2 = idx + 1
    }
    if packet.id == 1 {
      idx6 = idx + 1
    }
  }

  return idx2 * idx6
}

func Day13(input string) {
  linePairs := strings.Split(input, "\n\n")

  idxSum := Part1(linePairs)
  fmt.Printf("Index Sum of Pairs: %v\n", idxSum)

  decoderKey := Part2(linePairs)
  fmt.Printf("Decoder Key: %v\n", decoderKey)
}
