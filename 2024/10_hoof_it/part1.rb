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

def hoof_to(start, rating = false)
  q, v, t = [start], Set.new, 0
  while q.length > 0
    r,c = q.shift
    next if !rating && v.member?([r,c])

    v.add([r, c])

    next t += 1 if GRID[r][c] == 9

    neighbors = [
      [r - 1, c],
      [r, c - 1],
      [r + 1, c],
      [r, c + 1],
    ]

    neighbors.each { |(nr, nc)|
      next if v.member?([nr,nc])
      next unless GRID[nr][nc] == GRID[r][c] + 1
      q.push([nr, nc])
    }
  end
  t
end

puts starts.reduce(0) { |total, start|
  total + hoof_to(start)
}
