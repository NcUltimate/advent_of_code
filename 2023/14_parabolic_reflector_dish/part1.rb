lines = File.open(ARGV[0], 'r', &:readlines)

grid = lines.map { |line| line.chomp.chars }

grid.each_index do |row|
  grid[row].each_index do |col|
    cell = grid[row][col]
    next unless cell == 'O'

    new_row = row
    while new_row > 0 && grid[new_row - 1][col] == '.'
      new_row -= 1
    end

    grid[new_row][col] = 'O'
    if new_row != row
      grid[row][col] = '.'
    end
  end
end

total = grid.each_index.reduce(0) do |sum, row|
  puts grid[row].join
  sum + grid[row].count('O') * (grid.length - row)
end

puts total