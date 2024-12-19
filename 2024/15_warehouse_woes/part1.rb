grid, moves = File.open(ARGV[0], 'r', &:readlines)
  .map(&:chomp)
  .reject(&:empty?)
  .partition { |l| l.include?('#') }

grid = grid.map { |r| r.split('') }

robot = nil
grid.each_index { |r|
  grid[r].each_index { |c|
    robot = [r, c] if grid[r][c] == '@'
  }
}

MR = { '^' => -1, '>' => 0, '<' => 0, 'v' => 1 }
MC = { '^' => 0, '>' => 1, '<' => -1, 'v' => 0 }

moves = moves.join('').split('')
moves.each { |m|
  nr, nc = robot
  iter = 0
  while nr >= 0 && nc >= 0 && nr < grid.length && nc < grid[0].length && '@O'.include?(grid[nr][nc])
    nr += MR[m]
    nc += MC[m]
    iter += 1
  end

  next if nr < 0 || nc < 0 || nr >= grid.length || nc >= grid[0].length

  if grid[nr][nc] == '.'
    grid[nr][nc] = 'O' if iter > 1

    pr, pc = robot
    robot[0] += MR[m]
    robot[1] += MC[m]
    grid[robot[0]][robot[1]] = '@'
    grid[pr][pc] = '.'
  end
}

grid.each { |g| puts g.join(' ') }

puts grid.each_index.reduce(0) { |s, r|
  grid[r].each_index { |c|
    next unless grid[r][c] == 'O'
    s += 100 * r + c 
  }
  s
}
