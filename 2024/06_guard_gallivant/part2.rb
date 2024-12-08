sgrid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }

sg = sgrid.each_index.reduce([0,0]) { |g, r|
  sgrid[r].each_index.reduce(g) { |g2, c|
    '^>v<'.include?(sgrid[r][c]) ? [r,c] : g2
  }
}

so = sgrid[sg[0]][sg[1]]

TURN = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }
CHAR = { '^' => '|', 'v' => '|', '>' => '-', '<' => '-' }
DR = { '^' => -1, 'v' => 1, '<' => 0, '>' => 0 }
DC = { '^' => 0, 'v' => 0, '<' => -1, '>' => 1 }

def traverse(grid, g, o)
  visited = Array.new(grid.length) {
    Array.new(grid[0].length) {
      Hash.new { false }
    }
  }

  reason = ''
  loop do
    n = [
      g[0] + DR[o],
      g[1] + DC[o]
    ]

    if n[0] < 0 || n[1] < 0 || !grid[n[0]]&.[](n[1])
      reason = 'edge'
      break
    end

    if grid[n[0]][n[1]] == '#'
      o = TURN[o]
      grid[g[0]][g[1]] = '+'
    else
      g = n
      grid[g[0]][g[1]] = CHAR[o]
    end

    if visited[g[0]][g[1]][o]
      reason = 'loop'
      break
    end

    visited[g[0]][g[1]][o] = true
  end

  reason
end

initial = sgrid.map(&:dup)
debug = initial.map(&:dup)
traverse(initial, sg, so)

initial.each_index { |r|
  initial[r].each_index { |c|
    next unless initial[r][c] !~ /[.#]/

    grid = sgrid.map(&:dup)
    grid[r][c] = '#'

    reason = traverse(grid, sg, so)
    if reason == 'loop'
      debug[r][c] = 'O'
    end
  }
}

puts debug.reduce(0) { |s, r|
  puts r.join(' ')
  s + r.count { |c| c == 'O' }
}
