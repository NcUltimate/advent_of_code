grid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }

result = Array.new(grid.length) { Array.new(grid[0].length) }

count = 0

grid.each_index do |ridx|
  grid[ridx].each_index do |cidx|
    tb, rb, bb, lb = ridx < 3, cidx > grid[ridx].length - 4, ridx > grid.length - 4, cidx < 3

    n, ne, e, se, s, sw, w, nw = true, true, true, true, true, true, true, true
    'XMAS'.split('').each_with_index do |let, idx|
      if tb || grid[ridx - idx][cidx] != let
        n = false
      end

      if tb || rb || grid[ridx - idx][cidx + idx] != let
        ne = false
      end

      if rb || grid[ridx][cidx + idx] != let
        e = false
      end

      if rb || bb || grid[ridx + idx][cidx + idx] != let
        se = false
      end

      if bb || grid[ridx + idx][cidx] != let
        s = false
      end

      if bb || lb || grid[ridx + idx][cidx - idx] != let
        sw = false
      end

      if lb || grid[ridx][cidx - idx] != let
        w = false
      end

      if tb || lb || grid[ridx - idx][cidx - idx] != let
        nw = false
      end
    end

    num_xmas = [n, ne, e, se, s, sw, w, nw].count { |v| v }
    if num_xmas > 0
      count += num_xmas
      result[ridx][cidx] = "#{num_xmas}"
    else
      result[ridx][cidx] = '.'
    end
  end
end

result.each { |r| p r.join }

puts count
