require 'set'

lines = File.open(ARGV[0], 'r', &:readlines)

grid = lines.map { |line| line.chomp.chars }

grid.each do |row|
  puts row.join
end


def shift_north(grid)
  memo = Array.new(grid[0].length) { [] }

  row_iterator = (grid.length - 1).downto(-1)
  col_iterator = (0...grid[0].length)

  row_iterator.each do |row|
    col_iterator.each do |col|
      if row == -1 || grid[row][col] == '#'
        new_row = row + 1
        while memo[col].length > 0
          old_row = memo[col].pop
          grid[old_row][col] = '.'
          grid[new_row][col] = 'O'
          new_row += 1
        end
      elsif grid[row][col] == 'O'
        memo[col].push(row)
      end
    end
  end
end

def shift_west(grid)
  memo = Array.new(grid.length) { [] }

  row_iterator = (0...grid.length)
  col_iterator = (grid[0].length - 1).downto(-1)

  col_iterator.each do |col|
    row_iterator.each do |row|
      if col == -1 || grid[row][col] == '#'
        new_col = col + 1
        while memo[row].length > 0
          old_col = memo[row].pop
          grid[row][old_col] = '.'
          grid[row][new_col] = 'O'
          new_col += 1
        end
      elsif grid[row][col] == 'O'
        memo[row].push(col)
      end
    end
  end
end

def shift_east(grid)
  memo = Array.new(grid.length) { [] }

  row_iterator = (0...grid.length)
  col_iterator = (0..grid[0].length)

  col_iterator.each do |col|
    row_iterator.each do |row|
      if col == grid[0].length || grid[row][col] == '#'
        new_col = col - 1
        while memo[row].length > 0
          old_col = memo[row].pop
          grid[row][old_col] = '.'
          grid[row][new_col] = 'O'
          new_col -= 1
        end
      elsif grid[row][col] == 'O'
        memo[row].push(col)
      end
    end
  end
end

def shift_south(grid)
  memo = Array.new(grid[0].length) { [] }

  row_iterator = (0..grid.length)
  col_iterator = (0...grid[0].length)

  row_iterator.each do |row|
    col_iterator.each do |col|
      if row == grid.length || grid[row][col] == '#'
        new_row = row - 1
        while memo[col].length > 0
          old_row = memo[col].pop
          grid[old_row][col] = '.'
          grid[new_row][col] = 'O'
          new_row -= 1
        end
      elsif grid[row][col] == 'O'
        memo[col].push(row)
      end
    end
  end
end

puts

known_resting_states = {}

scores = []

final_resting_state = nil

1_000_000_000.times do |i|
  [:shift_north, :shift_west, :shift_south, :shift_east].each do |shift|
    method(shift).call(grid)
  end

  new_resting_state = grid.join { |row| row.join }

  if known_resting_states[new_resting_state]
    puts "Found a loop after #{i} iterations -- cycle is length #{i - known_resting_states[new_resting_state]}"
    puts "Last occurence was at #{known_resting_states[new_resting_state]}"

    first_occurrence = known_resting_states[new_resting_state]
    cycle_length = i - first_occurrence

    which_score = (1_000_000_000 - first_occurrence) % cycle_length + first_occurrence - 1
    final_resting_state = scores[which_score]
    break;
  end

  total = grid.each_index.reduce(0) do |sum, row|
    sum + grid[row].count('O') * (grid.length - row)
  end

  scores.push(total)

  known_resting_states[new_resting_state] = i
end

puts final_resting_state