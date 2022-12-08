package main

import (
  "strings"
  "strconv"
)

const rootSize = 40528671

func Day07(lines []string) []int{
  dir := 0
  maxDir := 0

  size := 0
  deleteSize := 70000000

  sizes := []int{0}

  for _, str := range lines {
    if len(str) <= 0 {
      continue;
    }

    if(str[0] == 36) { // cmd
      if(str[2] == 99) { // cd
        if(str[5] == 47) { // '/'
          // NOOP - ignore change dir to '/'
        } else if(str[5] == 46) { // '.'
          if(str[6] == 46) { // '.'
            if(sizes[dir] <= 100000) {
              size += sizes[dir]
            }
            if(rootSize - sizes[dir] < 40000000 && sizes[dir] < deleteSize) {
              deleteSize = sizes[dir]
            }
            sizes[dir-1] += sizes[dir]
            dir -= 1
          }
        } else {
          if(dir < maxDir) {
            dir += 1
            sizes[dir] = 0
          } else {
            sizes = append(sizes, 0)
            dir += 1
          }

          if(dir > maxDir) {
            maxDir = dir;
          }
        }
      } else { // ls
        // NOOP - we can ignore ls 
      }
    } else if(str[0] == 100) { // dir
      // NOOP - we can ignore dir
    } else { // numeric
      result, _ := strconv.Atoi(strings.Split(str, " ")[0])
      if(len(sizes) < maxDir){
        sizes[dir] = result
      } else {
        sizes[dir] += result
      }
    }
  }

  empiricalRootSize := 0

  for(dir >= 0) {
    if(sizes[dir] < 100000) {
      size += sizes[dir]
    }
    if(rootSize - sizes[dir] < 40000000 && sizes[dir] < deleteSize) {
      deleteSize = sizes[dir]
    }
    empiricalRootSize += sizes[dir]
    dir -= 1
  }

  return []int{empiricalRootSize, deleteSize, size}
}
