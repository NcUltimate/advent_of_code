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
      garden.add(neighbor.join('|'))

      neighbors(*neighbor).each { |n|
        next unless GARDENS[n[0]][n[1]] == id
        next if visited.member?(n)
        visited.add(n)
        q.push(n)
      }
    end

    area = garden.length
    perimeter = garden.reduce(0) { |p, g|
      gr, gc = g.split('|').map(&:to_i)
      p + neighbors(gr, gc).count { |(nr, nc)|
        id != GARDENS[nr][nc]
      }
    }

    rset, cset = Set.new, Set.new
    rmin, rmax, cmin, cmax = GARDENS.length, -1, GARDENS[0].length, -1
    garden.each { |g|
      gr, gc = g.split('|').map(&:to_i)
      rset.add(gr)
      cset.add(gc)
      rmin = [rmin, gr].min
      rmax = [rmax, gr].max
      cmin = [cmin, gc].min
      cmax = [cmax, gc].max
    }

    edges = 0
    (rmin - 1..rmax + 1).each { |ir|
      same, prevside1, prevside2 = true, false, false
      (cmin - 1..cmax + 1).each { |ic|
        side1, side2 = garden.member?("#{ir}|#{ic}"), garden.member?("#{ir - 1}|#{ic}") 
        if side1 != side2
          if same
            same = false
            edges += 1
          elsif prevside1 != prevside2 && (prevside1 != side1 || prevside2 != side2)
            edges += 1
          end
        else
          same = true
        end

        prevside1, prevside2 = side1, side2
      }
    }

    (cmin - 1..cmax + 1).each { |ic|
      same, prevside1, prevside2 = true, false, false
      (rmin - 1..rmax + 1).each { |ir|
        side1, side2 = garden.member?("#{ir}|#{ic}"), garden.member?("#{ir}|#{ic - 1}") 
        if side1 != side2
          if same
            same = false
            edges += 1
          elsif prevside1 != prevside2 && (prevside1 != side1 || prevside2 != side2)
            edges += 1
          end
        else
          same = true
        end

        prevside1, prevside2 = side1, side2
      }
    }

    results.push([perimeter, area, edges, id])
  }
}

puts results.reduce(0) { |s, garden|
  s + garden[1] * garden[2]
}
