a,b = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split(/\s+/) }
  .reject(&:empty?)
  .transpose
  .map { |l| l.map(&:to_i) }

h = b.each_with_object(Hash.new { 0 }) { |i,o| o[i] += 1 }

puts a.map { |i| h[i] * i }.sum
