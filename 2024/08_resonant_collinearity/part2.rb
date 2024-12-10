require 'set'

grid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }

def antinodes(*points, w, h)
  points.combination(2).reduce(Set.new) { |set, (p1, p2)|
    dr = p2[0] - p1[0]
    dc = p2[1] - p1[1]

    n = [(h/dr).abs, (w/dc).abs].max
    n.times { |k|
      set.add([p1[0] - k * dr, p1[1] - k * dc])
      set.add([p2[0] + k * dr, p2[1] + k * dc])
    }

    set
  }
end

antennae = {}
grid.each_index { |r|
  grid[r].each_index  { |c|
    next if grid[r][c] == '.'
    antennae[grid[r][c]] ||= []
    antennae[grid[r][c]].push([r,c])
  }
}

puts antennae.values.reduce(Set.new) { |set, locs|
  set + Set.new(antinodes(*locs, grid.length, grid[0].length).to_a.select { |n|
    n[0] >= 0 && n[1] >= 0 && n[0] < grid.length && n[1] < grid[0].length
  })
}.size

