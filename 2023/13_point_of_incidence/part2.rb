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

candidates = grids.map do |grid|
  sub_grids = []
  grid.each_index do |row|
    grid[row].chars.each_index do |col|
      if grid[row][col] == '#'
        sub_grid = grid.map(&:dup)
        sub_grid[row][col] = '.'
        sub_grids << sub_grid
      end
    end
  end

  possible_mirrors = []

  sub_grids.each do |sub_grid|
    mirror_rows = (0...sub_grid.length - 1).select do |idx|
      sub_grid[idx] == sub_grid[idx + 1]
    end

    mirror_rows = mirror_rows.select do |start|
      offset = 1
      mismatched = false
      while true
        is_l_bounded = start - offset >= 0
        is_r_bounded = start + offset + 1 <= sub_grid.length - 1
        break if !is_l_bounded || !is_r_bounded

        mismatched = sub_grid[start - offset] != sub_grid[start + offset + 1]
        break if mismatched

        offset += 1
      end

      !mismatched
    end

    transposed = sub_grid.map(&:chars).transpose.map(&:join)

    mirror_cols = (0...transposed.length - 1).select do |idx|
      transposed[idx] == transposed[idx + 1]
    end

    mirror_cols = mirror_cols.select do |start|
      offset = 1
      mismatched = false
      while true
        is_l_bounded = start - offset >= 0
        is_r_bounded = start + offset + 1 <= transposed.length - 1
        break if !is_l_bounded || !is_r_bounded

        mismatched = transposed[start - offset] != transposed[start + offset + 1]
        break if mismatched

        offset += 1
      end

      !mismatched
    end

    possible_mirrors
      .concat(mirror_rows.map { |row| [row, nil] })
      .concat(mirror_cols.map { |col| [nil, col] })
  end

  possible_mirrors
end

# mirrors contains an array of pairs of [row, col] where the row or col is an
# index. One or the other may be nil. Generate two maps of counts of only the
# non-nil entries, one per row and one per col.
mapped = candidates.map do |mirrors|
  row_counts = mirrors.reduce({}) do |counts, mirror|
    if mirror[0]
      counts[mirror[0]] ||= 0
      counts[mirror[0]] += 1
    end
    counts
  end

  col_counts = mirrors.reduce({}) do |counts, mirror|
    if mirror[1]
      counts[mirror[1]] ||= 0
      counts[mirror[1]] += 1
    end
    counts
  end

  # pick the key with lowest value from both maps
  row_min = row_counts.min_by { |k, v| v }
  col_min = col_counts.min_by { |k, v| v }

  if !row_min
    [nil, col_min[0]]
  elsif !col_min
    [row_min[0], nil]
  elsif row_min[1] < col_min[1]
    [row_min[0], nil]
  else
    [nil, col_min[0]]
  end
end

mapped.each_index do |idx|
  grids[idx].each_index do |row|
    puts grids[idx][row]
  end
  
  if mapped[idx][0]
    puts "Row #{mapped[idx][0] + 1}"
  else
    puts "Column #{mapped[idx][1] + 1}"
  end
  puts
end

total = mapped.reduce(0) do |sum, mirror|
  sum += 100 * (mirror[0] + 1) if mirror[0]
  sum += mirror[1] + 1 if mirror[1]
  sum
end

p total

