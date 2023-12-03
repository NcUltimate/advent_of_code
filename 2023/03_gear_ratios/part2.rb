require 'set'

grid = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

parts = Array.new(grid.length) { Array.new(grid[0].length) { [] } }
debug = Array.new(grid.length) { Array.new(grid[0].length) { ' ' } }

grid.each_with_index do |row, ridx|
  start_num_idx = row.index(/\d+/)
  cur_num_idx = start_num_idx

  # while there are numbers in the row
  while cur_num_idx
    gears = Set.new

    # read each digit
    while row[cur_num_idx] =~ /\d/
      if ridx > 0 && grid[ridx - 1][cur_num_idx] == '*'
        gears.add([ridx - 1, cur_num_idx])
      elsif ridx < grid.length - 1 && grid[ridx + 1][cur_num_idx] == '*'
        gears.add([ridx + 1, cur_num_idx])
      elsif cur_num_idx > 0 && row[cur_num_idx - 1] == '*'
        gears.add([ridx, cur_num_idx - 1])
      elsif cur_num_idx < row.length - 1 && row[cur_num_idx + 1] == '*'
        gears.add([ridx, cur_num_idx + 1])
      elsif ridx > 0 && cur_num_idx > 0 && grid[ridx - 1][cur_num_idx - 1] == '*'
        gears.add([ridx - 1, cur_num_idx - 1])
      elsif ridx > 0 && cur_num_idx < row.length - 1 && grid[ridx - 1][cur_num_idx + 1] == '*'
        gears.add([ridx - 1, cur_num_idx + 1])
      elsif ridx < grid.length - 1 && cur_num_idx > 0 && grid[ridx + 1][cur_num_idx - 1] == '*'
        gears.add([ridx + 1, cur_num_idx - 1])
      elsif ridx < grid.length - 1 && cur_num_idx < row.length - 1 && grid[ridx + 1][cur_num_idx + 1] == '*'
        gears.add([ridx + 1, cur_num_idx + 1])
      end

      cur_num_idx += 1
    end

    part = row[start_num_idx...cur_num_idx].to_i

    gears.each do |gear|
      (start_num_idx...cur_num_idx).each do |idx|
        debug[ridx][idx] = row[idx].to_s
      end

      parts[gear[0]][gear[1]].push(part)
    end

    start_num_idx = row.index(/\d+/, cur_num_idx + 1)
    cur_num_idx = start_num_idx
  end
end

count = 0

parts.each_with_index do |row, ridx|
  row.each_with_index do |gear_parts, cidx|
    debug[ridx][cidx] = '✅' if gear_parts.size == 2
    debug[ridx][cidx] = '❌' if gear_parts.size == 1
    if gear_parts.size == 2
      count += gear_parts.reduce(&:*)
    end
  end
end

debug.each do |row|
  puts row.join
end

puts count