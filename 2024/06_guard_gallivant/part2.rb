require 'set'

grid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }

g = grid.each_index.reduce([0,0]) { |g, r|
  grid[r].each_index.reduce(g) { |g2, c|
    '^>v<'.include?(grid[r][c]) ? [r,c] : g2
  }
}

o = grid[g[0]][g[1]]

d = Array.new(grid.length) { Array.new(grid[0].length) { Set.new } }

def get_next(pos, o)
  [
    pos[0] + (o =~ /[\^v]/ ? { '^' => -1, 'v' => 1 }[o] : 0),
    pos[1] + (o =~ /[<>]/ ? { '<' => -1, '>' => 1 }[o] : 0),
  ]
end

x = []

loop do
  d[g[0]][g[1]].add(o)
  grid[g[0]][g[1]] = 'x'

  ng = get_next(g, o)
  break if !grid[ng[0]]&.[](ng[1])

  no = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }[o]
  if grid[ng[0]][ng[1]] == '#'
    o = no
  else
    g = ng
  end

  neighb = get_next(ng, no)
  x.push(get_next(g, o)) if d[neighb[0]][neighb[1]].member?(no)

  grid[g[0]][g[1]] = o
end

puts grid.reduce(0) { |s, r|
  puts r.join(' ')
  s + r.count { |c| c !~ /[#\.]/ }
}

x.each { |c| p c }
