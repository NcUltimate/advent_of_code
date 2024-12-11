require 'set'

GRID = File.open(ARGV[0], 'r', &:readlines)
  .map { |r| r.chomp.split('').map(&:to_i) }
  .each { |r| r.unshift(-1); r.push(-1) }

GRID.unshift(Array.new(GRID[0].length) { -1 })
GRID.push(Array.new(GRID[0].length) { -1 })

starts = GRID.each_index.each_with_object([]) { |ridx, s|
  GRID[ridx].each_index { |cidx|
    s.push([ridx, cidx]) if GRID[ridx][cidx] == 0
  }
}

V = Set.new
def hoof_to(r,c, rating = false)
  V.add([r, c])
  return 1 if GRID[r][c] == 9

  neighbors = [
    [r - 1, c],
    [r, c - 1],
    [r + 1, c],
    [r, c + 1],
  ]

  neighbors.reduce(0) { |total, (nr, nc)|
    next total if !rating && V.member?([nr,nc])
    next total unless GRID[nr][nc] == GRID[r][c] + 1
    total + hoof_to(nr, nc, rating)
  }
end

puts starts.reduce(0) { |total, start|
  V.clear
  total + hoof_to(*start, true)
}
