package main

const (
  N = iota
  S
  E
  W
)

func Part1(forest [][]int) int {
  size := len(forest)

  visible := make([][]int, size)
  for i := 0; i < size; i++ {
    visible[i] = make([]int, size)
  }

  for i := 0; i < size; i++ {
    maxN := forest[0][i]
    maxS := forest[size-1][i]
    maxE := forest[i][size - 1]
    maxW := forest[i][0]

    for j := 0; j < size; j++ {
      if i == 0 || j == 0 || i == size - 1 || j == size - 1 {
        visible[i][j] = 1
      }

      w := j
      n := j
      e := size - w - 1
      s := size - n - 1
      
      treeN := forest[n][i]
      treeS := forest[s][i]
      treeE := forest[i][e]
      treeW := forest[i][w]

      if treeN > maxN {
        maxN = treeN
        visible[n][i] = 1
      }

      if treeS > maxS {
        maxS = treeS
        visible[s][i] = 1
      }

      if treeE > maxE {
        maxE = treeE
        visible[i][e] = 1
      }

      if treeW > maxW {
        maxW = treeW
        visible[i][w] = 1
      }
    }
  }

  visibleCount := 0
  for i := range visible {
    for _, v := range visible[i] {
      visibleCount += v
    }
  }

  return visibleCount
}

func Part2(forest [][]int) int {
  size := len(forest)

  scenic := make([][][]int, size)
  max := make([][][]int, size)

  for i := 0; i < size; i++ {
    scenic[i] = make([][]int, size)
    max[i] = make([][]int, size)

    for j := 0; j < size; j++ {
      scenic[i][j] = []int{ 0, 0, 0, 0}
      max[i][j] = []int{ -1, -1, -1, -1}
    }
  }

  for i := 1; i < size; i++ {
    for j := 0; j < size; j++ {
      // North
      if forest[i][j] > forest[i-1][j] {
        maxIdx := max[i-1][j][N]
        for maxIdx != -1 && forest[i][j] > forest[maxIdx][j] {
          maxIdx = max[maxIdx][j][N]
        }

        if(maxIdx == -1) {
          scenic[i][j][N] = i 
        } else {
          scenic[i][j][N] = i - maxIdx
        }

        max[i][j][N] = maxIdx
      } else if forest[i][j] == forest[i-1][j] {
        scenic[i][j][N] = 1
        max[i][j][N] = max[i-1][j][N]
      } else {
        scenic[i][j][N] = 1
        max[i][j][N] = i - 1
      }

      // South
      if forest[size-i-1][j] > forest[size-i][j] {
        maxIdx := max[size - i][j][S]
        for maxIdx != -1 && forest[size-i-1][j] > forest[maxIdx][j] {
          maxIdx = max[maxIdx][j][S]
        }

        if(maxIdx == -1) {
          scenic[size - i - 1][j][S] = i 
        } else {
          scenic[size - i - 1][j][S] = maxIdx - (size - i - 1)
        }

        max[size - i - 1][j][S] = maxIdx
      } else if forest[size-i-1][j] == forest[size-i][j] {
        scenic[size - i - 1][j][S] = 1
        max[size - i - 1][j][S] = max[size - i][j][S]
      } else {
        scenic[size - i - 1][j][S] = 1
        max[size - i - 1][j][S] = size - i
      }

      // East
      if forest[j][i] > forest[j][i-1] {
        maxIdx := max[j][i-1][E]
        for maxIdx != -1 && forest[j][i] > forest[j][maxIdx] {
          maxIdx = max[j][maxIdx][E]
        }

        if(maxIdx == -1) {
          scenic[j][i][E] = i 
        } else {
          scenic[j][i][E] = i - maxIdx
        }

        max[j][i][E] = maxIdx
      } else if forest[j][i] == forest[j][i-1] {
        scenic[j][i][E] = 1
        max[j][i][E] = max[j][i-1][E]
      } else {
        scenic[j][i][E] = 1
        max[j][i][E] = i - 1
      }

      // West
      if forest[j][size-i-1] > forest[j][size-i] {
        maxIdx := max[j][size - i][W]
        for maxIdx != -1 && forest[j][size-i-1] > forest[j][maxIdx] {
          maxIdx = max[j][maxIdx][W]
        }

        if(maxIdx == -1) {
          scenic[j][size - i - 1][W] = i 
        } else {
          scenic[j][size - i - 1][W] = maxIdx - (size - i - 1)
        }

        max[j][size - i - 1][W] = maxIdx
      } else if forest[W][size - i - 1] == forest[j][size - i] {
        scenic[j][size - i - 1][W] = 1
        max[j][size - i - 1][W] = max[j][size - i][W]
      } else {
        scenic[j][size - i - 1][W] = 1
        max[j][size - i - 1][W] = size - i
      }
    }
  }

  maxScenic := 0
  for i := range scenic {
    for j := range scenic[i] {
      localScenic := 1
      for d := range scenic[i][j] {
        localScenic *= scenic[i][j][d]
      }

      if localScenic > maxScenic {
        maxScenic = localScenic
      }
    }
  }

  return maxScenic
}
