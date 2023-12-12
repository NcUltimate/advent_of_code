lines = File.open(ARGV[0], 'r', &:readlines)

grid = Array.new(2 * lines.length + 2) { Array.new(2 * lines[0].length + 2, '.') }

start = [0, 0]

lines.each_with_index do |line, row|
  line.chomp.chars.each_with_index do |char, col|
    grid[2 * row + 1][2 * col + 1] = char

    start = [2 * row + 1, 2 * col + 1, 'N'] if char == 'S'
  end
end

# Step 1: Expand the grid with extra rows and columns
(1...grid.length - 1).each do |row|
  (1...grid[row].length - 1).each do |col|

    if grid[row][col] == 'J'
      grid[row][col-1] = '-' if grid[row][col-1] == '.'
      grid[row-1][col] = '|' if grid[row-1][col] == '.'
    end

    if grid[row][col] == 'L'
      grid[row][col+1] = '-' if grid[row][col+1] == '.'
      grid[row-1][col] = '|' if grid[row-1][col] == '.'
    end

    if grid[row][col] == '7'
      grid[row][col-1] = '-' if grid[row][col-1] == '.'
      grid[row+1][col] = '|' if grid[row+1][col] == '.'
    end

    if grid[row][col] == 'F'
      grid[row][col+1] = '-' if grid[row][col+1] == '.'
      grid[row+1][col] = '|' if grid[row+1][col] == '.'
    end

    if grid[row][col] == '|'
      grid[row-1][col] = '|' if grid[row-1][col] == '.'
      grid[row+1][col] = '|' if grid[row+1][col] == '.'
    end

    if grid[row][col] == '-'
      grid[row][col-1] = '-' if grid[row][col-1] == '.'
      grid[row][col+1] = '-' if grid[row][col+1] == '.'
    end
  end
end

# Step 2: Find the loop
queue = [
  [start[0], start[1] + 1, 'E', 1, grid[start[0]][start[1] + 1]],
  [start[0], start[1] - 1, 'W', 1, grid[start[0]][start[1] - 1]],
  [start[0] + 1, start[1], 'S', 1, grid[start[0] + 1][start[1]]],
  [start[0] - 1, start[1], 'N', 1, grid[start[0] - 1][start[1]]],
]

in_loop = Array.new(grid.length + 2) { Array.new(grid[0].length + 1, '◦') }

in_loop[start[0]][start[1]] = '◘'

while !queue.empty?
  row, col, dir, len = queue.shift
  next if grid[row][col] == '.'

  case grid[row][col]
  when '|'
    in_loop[row][col] = '┃'
    if dir == 'N'
      queue.push([row - 1, col, 'N', len + 1, grid[row - 1][col]])
    elsif dir == 'S'
      queue.push([row + 1, col, 'S', len + 1, grid[row + 1][col]])
    end
  when '-'
    in_loop[row][col] = '━'
    if dir == 'E'
      queue.push([row, col + 1, 'E', len + 1, grid[row][col + 1]])
    elsif dir == 'W'
      queue.push([row, col - 1, 'W', len + 1, grid[row][col - 1]])
    end
  when '7'
    in_loop[row][col] = '┓'
    if dir == 'N'
      queue.push([row, col - 1, 'W', len + 1, grid[row][col - 1]])
    elsif dir == 'E'
      queue.push([row + 1, col, 'S', len + 1, grid[row + 1][col]])
    end
  when 'L'
    in_loop[row][col] = '┗'
    if dir == 'S'
      queue.push([row, col + 1, 'E', len + 1, grid[row][col + 1]])
    elsif dir == 'W'
      queue.push([row - 1, col, 'N', len + 1, grid[row - 1][col]])
    end
  when 'J'
    in_loop[row][col] = '┛'
    if dir == 'S'
      queue.push([row, col - 1, 'W', len + 1, grid[row][col - 1]])
    elsif dir == 'E'
      queue.push([row - 1, col, 'N', len + 1, grid[row - 1][col]])
    end
  when 'F'
    in_loop[row][col] = '┏'
    if dir == 'N'
      queue.push([row, col + 1, 'E', len + 1, grid[row][col + 1]])
    elsif dir == 'W'
      queue.push([row + 1, col, 'S', len + 1, grid[row + 1][col]])
    end
  end
end

# Step 3: Flood fill the loop from the outer edge, marking all cells that are
#         not part of the loop
flood_q = [[0,0]]
while !flood_q.empty?
  row, col = flood_q.shift

  [[row + 1, col], [row - 1, col], [row, col + 1], [row, col - 1]].each do |r, c|
    next if in_loop[r][c] != '◦'

    in_loop[r][c] = '╳'
    flood_q.push([r, c])
  end
end

# Step 4: Re-mark all padded cells as '.' to factor them out of the final count
in_loop.each_index do |row|
  in_loop[row].each_index do |col|
    if row % 2 == 0 && col % 2 == 0
      in_loop[row][col] = '.'
    elsif row % 2 == 0
      in_loop[row][col] = '.'
    elsif col % 2 == 0
      in_loop[row][col] = '.'
    end
  end
end

# Step 5: Print the loop and count the number of cells in the loop
in_loop.each_index do |row|
  next if row % 2 == 0
  puts in_loop[row].reject { |r| r == '.' }.join
end

puts in_loop.reduce(0) { |rsum, row| rsum + row.reduce(0) { |csum, col| csum + (col == '◦' ? 1 : 0) } }
