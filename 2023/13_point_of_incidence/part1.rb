lines = File.open(ARGV[0], 'r', &:readlines)

grids = []
current_grid = []

lines.each_index do |idx|
  if lines[idx].chomp.length == 0
    grids << current_grid
    current_grid = []
  else
    current_grid << lines[idx].chomp
  end
end

grids << current_grid
current_grid = []

mapped = grids.map do |grid|
  mirror_rows = (0...grid.length - 1).select do |idx|
    grid[idx] == grid[idx + 1]
  end

  mirror_row = mirror_rows.find do |mirror_row|
    offset = 1
    mismatched = false
    while true
      is_l_bounded = mirror_row - offset >= 0
      is_r_bounded = mirror_row + offset + 1 <= grid.length - 1
      break if !is_l_bounded || !is_r_bounded

      mismatched = grid[mirror_row - offset] != grid[mirror_row + offset + 1]
      break if mismatched

      offset += 1
    end

    !mismatched
  end

  transposed = grid.map(&:chars).transpose.map(&:join)

  mirror_cols = (0...transposed.length - 1).select do |idx|
    transposed[idx] == transposed[idx + 1]
  end

  mirror_col = mirror_cols.find do |mirror_col|
    offset = 1
    mismatched = false
    while true
      is_l_bounded = mirror_col - offset >= 0
      is_r_bounded = mirror_col + offset + 1 <= transposed.length - 1
      break if !is_l_bounded || !is_r_bounded

      mismatched = transposed[mirror_col - offset] != transposed[mirror_col + offset + 1]
      break if mismatched

      offset += 1
    end

    !mismatched
  end

  [mirror_row, mirror_col]
end

total = mapped.reduce(0) do |sum, mirror|
  sum += 100 * (mirror[0] + 1) if mirror[0]
  sum += mirror[1] + 1 if mirror[1]
  sum
end

p total

