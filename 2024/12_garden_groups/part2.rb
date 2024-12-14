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

# Preprocess to rename duplicate regions by doing a BFS "wash"
# starting at each (x,y) and reassigning a utf8 char to the grid
visited = Set.new
uniq = Set.new

redress = 32

(1...GARDENS.length - 1).each { |r|
  (1...GARDENS[r].length - 1).each { |c|
    next if visited.member?([r, c])
    visited.add([r, c])

    id = GARDENS[r][c]
    area = Set.new 
    q = [[r, c]]
    while !q.empty?
      neighbor = q.shift

      visited.add(neighbor)
      area.add(neighbor)

      neighbors(*neighbor).each { |n|
        next unless GARDENS[n[0]][n[1]] == id
        next if visited.member?(n)
        visited.add(n)
        q.push(n)
      }
    end

    area.each { |n|
      redress += 1 if [redress].pack('U') == '.'
      GARDENS[n[0]][n[1]] = [redress].pack('U')
    }
    
    redress += 1
  }
}

# Calculate areas
perimeters = Hash.new { 0 }
areas = Hash.new { 0 }

(1...GARDENS.length - 1).each { |r|
  (1...GARDENS[r].length - 1).each { |c|
    garden = GARDENS[r][c]
    perimeters[garden] += neighbors(r, c).count { |(nr, nc)|
      garden != GARDENS[nr][nc]
    }

    areas[garden] += 1
  }
}

puts perimeters.keys.reduce(0) { |s, g|
  s + perimeters[g] * areas[g]
}
