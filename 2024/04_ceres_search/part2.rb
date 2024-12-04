grid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }
  .reject(&:empty?)

result = Array.new(grid.length) { Array.new(grid[0].length) { '.' } }

count = 0

grid.each_index do |ridx|
  grid[ridx].each_index do |cidx|
    tb, rb, bb, lb = ridx < 1, cidx > grid[ridx].length - 2, ridx > grid.length - 2, cidx < 1

    next if tb || rb || bb || lb
    next if grid[ridx][cidx] != 'A'

    nw = grid[ridx - 1][cidx - 1]
    ne = grid[ridx - 1][cidx + 1]
    sw = grid[ridx + 1][cidx - 1]
    se = grid[ridx + 1][cidx + 1]

    if /(SM|MS){2}/ =~ (nw + se + ne + sw)
      count += 1
      result[ridx][cidx] = "X"
    else
      result[ridx][cidx] = '.'
    end
  end
end

result.each { |r| p r.join }

puts count
