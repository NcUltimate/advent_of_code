lines = File.open(ARGV[0], 'r', &:readlines)

grid = Array.new(lines.length + 2) { Array.new(lines[0].length + 1, '.') }

start = [0, 0]

lines.each_with_index do |line, row|
  line.chomp.chars.each_with_index do |char, col|
    grid[row + 1][col + 1] = char

    start = [row + 1, col + 1, 'N'] if char == 'S'
  end
end

queue = [
  [start[0], start[1] + 1, 'E', 1, grid[start[0]][start[1] + 1]],
  [start[0], start[1] - 1, 'W', 1, grid[start[0]][start[1] - 1]],
  [start[0] + 1, start[1], 'S', 1, grid[start[0] + 1][start[1]]],
  [start[0] - 1, start[1], 'N', 1, grid[start[0] - 1][start[1]]],
]

max_len = 0

while !queue.empty?
  row, col, dir, len = queue.shift

  max_len = [max_len, len].max

  case grid[row][col]
  when '|'
    if dir == 'N'
      queue.push([row - 1, col, 'N', len + 1, grid[row - 1][col]])
    elsif dir == 'S'
      queue.push([row + 1, col, 'S', len + 1, grid[row + 1][col]])
    end
  when '-'
    if dir == 'E'
      queue.push([row, col + 1, 'E', len + 1, grid[row][col + 1]])
    elsif dir == 'W'
      queue.push([row, col - 1, 'W', len + 1, grid[row][col - 1]])
    end
  when '7'
    if dir == 'N'
      queue.push([row, col - 1, 'W', len + 1, grid[row][col - 1]])
    elsif dir == 'E'
      queue.push([row + 1, col, 'S', len + 1, grid[row + 1][col]])
    end
  when 'L'
    if dir == 'S'
      queue.push([row, col + 1, 'E', len + 1, grid[row][col + 1]])
    elsif dir == 'W'
      queue.push([row - 1, col, 'N', len + 1, grid[row - 1][col]])
    end
  when 'J'
    if dir == 'S'
      queue.push([row, col - 1, 'W', len + 1, grid[row][col - 1]])
    elsif dir == 'E'
      queue.push([row - 1, col, 'N', len + 1, grid[row - 1][col]])
    end
  when 'F'
    if dir == 'N'
      queue.push([row, col + 1, 'E', len + 1, grid[row][col + 1]])
    elsif dir == 'W'
      queue.push([row + 1, col, 'S', len + 1, grid[row + 1][col]])
    end
  end
end

p max_len / 2

