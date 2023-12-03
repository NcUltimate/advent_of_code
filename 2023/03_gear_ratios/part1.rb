grid = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

count = 0

grid.each_with_index do |row, ridx|
  start_num_idx = row.index(/\d+/)
  cur_num_idx = start_num_idx

  # while there are numbers in the row
  while cur_num_idx
    is_part = false

    # read each digit
    while row[cur_num_idx] =~ /\d/
      if ridx > 0 && grid[ridx - 1][cur_num_idx] =~ /[^.\d]/
        is_part = true
      elsif ridx < grid.length - 1 && grid[ridx + 1][cur_num_idx] =~ /[^.\d]/
        is_part = true
      elsif cur_num_idx > 0 && row[cur_num_idx - 1] =~ /[^.\d]/
        is_part = true
      elsif cur_num_idx < row.length - 1 && row[cur_num_idx + 1] =~ /[^.\d]/
        is_part = true
      elsif ridx > 0 && cur_num_idx > 0 && grid[ridx - 1][cur_num_idx - 1] =~ /[^.\d]/
        is_part = true
      elsif ridx > 0 && cur_num_idx < row.length - 1 && grid[ridx - 1][cur_num_idx + 1] =~ /[^.\d]/
        is_part = true
      elsif ridx < grid.length - 1 && cur_num_idx > 0 && grid[ridx + 1][cur_num_idx - 1] =~ /[^.\d]/
        is_part = true
      elsif ridx < grid.length - 1 && cur_num_idx < row.length - 1 && grid[ridx + 1][cur_num_idx + 1] =~ /[^.\d]/
        is_part = true
      end

      cur_num_idx += 1
    end

    if is_part
      part = row[start_num_idx..cur_num_idx].to_i
      count += part
    end

    start_num_idx = row.index(/\d+/, cur_num_idx + 1)
    cur_num_idx = start_num_idx
  end
end

puts count