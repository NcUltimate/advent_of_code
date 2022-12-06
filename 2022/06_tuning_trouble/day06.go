package main

func Day06(str string, length int) int {
  consec := 0
  counts := make([]byte, 128)
  for i := 0; i < len(str); i++ {
    if(i > length - 1) {
      counts[str[i-length]] -= 1;
      if(counts[str[i-length]] <= 0) {
        consec -= 1
      }
    }

    if counts[str[i]] == 0 {
      consec += 1
    }

    counts[str[i]] += 1;

    if consec == length {
      return i + 1
    }
  }

  return -1
}
