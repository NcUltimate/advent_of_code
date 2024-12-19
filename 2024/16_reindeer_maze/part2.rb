require 'set'

maze = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp }

start, finish = nil, nil
maze.each_index { |r|
  maze[r].length.times { |c|
    start = [r,c] if maze[r][c] == 'S'
    finish = [r,c] if maze[r][c] == 'E'
  }
}

TURNREG = /[<>][\^v]|[\^v][<>]/
ILLEGAL = /<>|\^v|><|v\^/
ROTATE = { '^' => '<', '<' => 'v', 'v' => '>', '>' => '^' }

min, pq, v = Float::INFINITY, [[start, '>', 0]], Set.new
while !pq.empty?
  point, prevdir, prevscore = pq.shift
  r, c = point
  next if v.member?([r, c, prevdir])

  if point == finish
    min = prevscore if prevscore < min
    break
  end

  v.add([r, c, prevdir])
  maze[r][c] = prevdir if maze[r][c] != 'S'

  neighbors = [
    [r-1, c, '^'],
    [r+1, c, 'v'],
    [r, c-1, '<'],
    [r, c+1, '>'],
    [r, c, ROTATE[prevdir]]
  ]

  neighbors.each { |(nr, nc, dir)|
    next if v.member?([nr, nc, dir])
    next if (prevdir+dir) =~ ILLEGAL
    next unless '.ES'.include?(maze[nr][nc])

    score = (prevdir + dir) =~ TURNREG ? 1001 : 1
    idx = [*pq.each_index].bsearch { |x|
      pq[x][2] >= prevscore + score
    }

    idx ||= -1

    pq.insert(idx, [[nr, nc], dir, prevscore + score])
  }
end

p start
p finish
maze.each { |r| puts r }

puts min
