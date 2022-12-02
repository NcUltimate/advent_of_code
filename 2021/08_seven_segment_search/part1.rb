input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

input = input.map do |line|
  line.split(/\s*\|\s*/)[1].split(/\s+/)
end

num_1478 = input.reduce(0) do |sum, line|
  sum + line.count do |disp|
    [2,3,4,7].include?(disp.size)
  end
end

puts num_1478

