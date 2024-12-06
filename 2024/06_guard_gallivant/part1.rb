grid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }

g = grid.each_index.reduce([0,0]) { |g, r|
  grid[r].each_index.reduce(g) { |g2, c|
    '^>v<'.include?(grid[r][c]) ? [r,c] : g2
  }
}

o = grid[g[0]][g[1]]

loop do
  grid[g[0]][g[1]] = 'x'

  n = [
    g[0] + (o =~ /[\^v]/ ? { '^' => -1, 'v' => 1 }[o] : 0),
    g[1] + (o =~ /[<>]/ ? { '<' => -1, '>' => 1 }[o] : 0),
  ]

  break if !grid[n[0]]&.[](n[1])

  if grid[n[0]][n[1]] == '#'
    o = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }[o]
  else
    g = n
  end

  grid[g[0]][g[1]] = o
end

puts grid.reduce(0) { |s, r|
  puts r.join(' ')
  s + r.count { |c| c !~ /[#\.]/ }
}
