require 'set'

GARDENS = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| ['.', *l.chomp.split(''), '.'] }

GARDENS.unshift(['.'] * GARDENS[0].length)
GARDENS.push(['.'] * GARDENS[0].length) 

def neighbors(r, c)
  [
    [r - 1, c],
    [r + 1, c],
    [r, c - 1],
    [r, c + 1],
  ]
end

results = []

visited = Set.new
uniq = Set.new

(1...GARDENS.length - 1).each { |r|
  (1...GARDENS[r].length - 1).each { |c|
    next if visited.member?([r, c])
    visited.add([r, c])

    id = GARDENS[r][c]
    garden = Set.new 
    q = [[r, c]]
    while !q.empty?
      neighbor = q.shift

      visited.add(neighbor)
      garden.add(neighbor)

      neighbors(*neighbor).each { |n|
        next unless GARDENS[n[0]][n[1]] == id
        next if visited.member?(n)
        visited.add(n)
        q.push(n)
      }
    end

    area = garden.length
    perimeter = garden.reduce(0) { |p, g|
      p + neighbors(g[0], g[1]).count { |(nr, nc)|
        id != GARDENS[nr][nc]
      }
    }

    results.push([perimeter, area])
  }
}

puts results.reduce(0) { |s, garden|
  s + garden[0] * garden[1]
}
