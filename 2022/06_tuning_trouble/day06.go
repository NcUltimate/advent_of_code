package main

func Day06(str string, length int) int {
  counts := make(map[byte]int, length)
  for i := 0; i < len(str); i++ {
    if(i > length - 1) {
      counts[str[i-length]] -= 1;
      if(counts[str[i-length]] == 0) {
        delete(counts, str[i-length])
      }
    }

    if _, ok := counts[str[i]]; ok {
      counts[str[i]] += 1;
    } else {
      counts[str[i]] = 1
    }

    if len(counts) == length {
      return i + 1
    }
  }

  return -1
}
