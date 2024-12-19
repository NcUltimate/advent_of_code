require 'set'

grid, moves = File.open(ARGV[0], 'r', &:readlines)
  .map(&:chomp)
  .reject(&:empty?)
  .partition { |l| l.include?('#') }

GRID = grid.map { |r|
  r.gsub('#', '##')
    .gsub('O', '[]')
    .gsub('.', '..')
    .gsub('@', '@.')
}

robot = nil
GRID.each_index { |r|
  GRID[r].length.times { |c|
    robot = [r, c] if GRID[r][c] == '@'
  }
}

MR = { '^' => -1, '>' => 0, '<' => 0, 'v' => 1 }
MC = { '^' => 0, '>' => 1, '<' => -1, 'v' => 0 }

moves = moves.join('').split('')

class RowSearch
  attr_accessor :v
  def initialize
    @v = Set.new
  end

  def next_open_row(r, c, d)
    dr = MR[d]
    return nil if GRID[r][c] == '#'
    return r if GRID[r][c] == '.'
    
    left, right = nil, nil
    if GRID[r][c] == '['
      left = next_open_row(r + dr, c, d)
      return nil unless left

      right = next_open_row(r + dr, c + 1, d)
    
      return nil unless right

      @v.add([r, c])

      d == '^' ? [left, right].min : [left, right].max
    elsif GRID[r][c] == ']'
      next_open_row(r, c - 1, d)
    end
  end
end

moves.each { |m|
  if m == '<'
    lspace = GRID[robot[0]].rindex('.', robot[1])
    locto = GRID[robot[0]].rindex('#', robot[1])
    next unless lspace && locto && lspace > locto

    if lspace == robot[1] - 1
      GRID[robot[0]][lspace] = '@'
    else
      GRID[robot[0]][lspace..robot[1] - 1] = GRID[robot[0]][lspace + 1..robot[1]]
    end

    GRID[robot[0]][robot[1]] = '.'
    robot[1] -= 1
  elsif m == '>'
    rspace = GRID[robot[0]].index('.', robot[1])
    rocto = GRID[robot[0]].index('#', robot[1])
    next unless rspace && rocto && rspace < rocto

    if rspace == robot[1] + 1
      GRID[robot[0]][rspace] = '@'
    else
      GRID[robot[0]][robot[1] + 1..rspace] = GRID[robot[0]][robot[1]..rspace - 1]
    end

    GRID[robot[0]][robot[1]] = '.'
    robot[1] += 1
  elsif m == '^' || m == 'v'
    dr = MR[m]
    rs = RowSearch.new
    nor = rs.next_open_row(robot[0] + dr, robot[1], m)
    next unless nor
    
    sorted = rs.v.sort { |a, b|
      m == '^' ? a[0] <=> b[0] : b[0] <=> a[0]
    }

    sorted.each { |(rsr, rsc)|
      GRID[rsr + dr][rsc] = '['
      GRID[rsr + dr][rsc + 1] = ']'
      GRID[rsr][rsc] = '.'
      GRID[rsr][rsc + 1] = '.'
    }
    GRID[robot[0]][robot[1]] = '.'
    GRID[robot[0] + dr][robot[1]] = '@'
    robot[0] += dr
  end
}

GRID.each { |r| puts r }

puts GRID.length.times.reduce(0) { |s, r|
  s + GRID[r].length.times.reduce(0) { |s2, c|
    GRID[r][c] == '[' ? s2 + 100 * r + c : s2
  }
}
