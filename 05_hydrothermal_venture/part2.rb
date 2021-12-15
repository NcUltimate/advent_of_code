rlines = File.open(ARGV[0], 'r', &:read)
rlines = rlines.gsub(/->/, '').split(/[\s,]+/).map(&:to_i)

lines = rlines.each_slice(2).each_slice(2)

hvlines = lines.select do |l|
  l[0][0] == l[1][0] || l[0][1] == l[1][1]
end

more_than_22 = 0
grid = lines.each_with_object({}) do |line, grid|
  diffx = 
    if line[0][0] < line[1][0]
      1
    elsif line[0][0] > line[1][0]
      -1
    else
      0
    end

  diffy = 
    if line[0][1] < line[1][1]
      1
    elsif line[0][1] > line[1][1]
      -1
    else
      0
    end

  xs = line[0][0]
  ys = line[0][1]
  loop do
    grid[xs] ||= {}
    grid[xs][ys] ||= 0
    grid[xs][ys] += 1
    more_than_22 += 1 if grid[xs][ys] == 2

    break if xs == line[1][0] && ys == line[1][1]

    xs += diffx
    ys += diffy
  end
end

puts more_than_22