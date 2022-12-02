rlines = File.open(ARGV[0], 'r', &:read)
rlines = rlines.gsub(/->/, '').split(/[\s,]+/).map(&:to_i)

lines = rlines.each_slice(2).each_slice(2)

hvlines = lines.select do |l|
  l[0][0] == l[1][0] || l[0][1] == l[1][1]
end

more_than_2 = 0
grid = hvlines.each_with_object({}) do |line, grid|
  minx = [line[0][0], line[1][0]].min
  maxx = [line[0][0], line[1][0]].max
  miny = [line[0][1], line[1][1]].min
  maxy = [line[0][1], line[1][1]].max

  (minx..maxx).each do |x|
    (miny..maxy).each do |y|
      grid[x] ||= {}
      grid[x][y] ||= 0
      grid[x][y] += 1
      more_than_2 += 1 if grid[x][y] == 2
    end
  end
end

puts more_than_2