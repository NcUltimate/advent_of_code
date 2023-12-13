lines = File.open(ARGV[0], 'r', &:readlines)
grid = lines.map { |line| line.chomp.chars }

no_galaxy_rows = grid.each_index.select { |row| grid[row].all? { |cell| cell == '.' } }

transposed = grid.transpose
no_galaxy_cols = transposed.each_index.select { |col| transposed[col].all? { |cell| cell == '.' } }

galaxies = []

grid.each_index do |row|
  grid[row].each_index do |col|
    if grid[row][col] == '#'
      galaxies << [row, col]
    end
  end
end

count = 0
total_dist = galaxies.each_index.reduce(0) do |sum, g1|
  (g1...galaxies.length).each do |g2|
    next if g1 == g2

    row1, col1 = galaxies[g1]
    row2, col2 = galaxies[g2]

    rows = [row1, row2].sort
    cols = [col1, col2].sort

    dist = cols[1] - cols[0] + rows[1] - rows[0]

    dist += 999999 * no_galaxy_cols.count { |col| cols[0] < col && col < cols[1] }
    dist += 999999 * no_galaxy_rows.count { |row| rows[0] < row && row < rows[1] }

    sum += dist
    count += 1
  end

  sum
end

puts total_dist
