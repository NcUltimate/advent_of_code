# Determining each segment

1. `1, 4, 7, 8` are all known due to unique segment counts. Segment `d` can be determined by diffing the segments of `1` and `7`.

  ```
  # Numbers
  acedgfb = 8
  dab = 7
  eafb = 4
  ab = 1

  # Segments
  d = top
  ```

2. `0, 6, 9` share the same number of segments. `6` must be the only one of this set which does not contain both `a` and `b` segments from `1`. The missing segment, `a`, must be the top right segment, and the remaining segment, `b`, must be the bottom right segment.

  ```
  # Numbers
  acedgfb = 8
  dab = 7
  eafb = 4
  ab = 1
  cdfgeb = 6

  # Segments
  d = top
  a = top right
  b = bottom right
  ```

3. `2, 3, 5` share the same number of segments. We can determine all 3 with our new knowledge of the top right and bottom right segment -- `2` will have only the top right segment, `3` will have both segments, and `5` will have only the bottom right segment.

  ```
  # Numbers
  acedgfb = 8
  dab = 7
  eafb = 4
  ab = 1
  cdfgeb = 6
  cdfbe = 5
  gcdfa = 2
  fbcad = 3

  # Segments
  d = top
  a = top right
  b = bottom right
  ```

4. We can now determine `0` and `9`. `9` is `5` plus the top right segment. The only remaining sequence must then be `0`.

  ```
  # Numbers
  acedgfb = 8
  dab = 7
  eafb = 4
  ab = 1
  cdfgeb = 6
  cdfbe = 5
  gcdfa = 2
  fbcad = 3
  cefabd = 9
  cagedb = 0

  # Segments
  d = top
  a = top right
  b = bottom right
  ```