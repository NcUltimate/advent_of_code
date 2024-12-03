puts File.open(ARGV[0], 'r', &:read)
  .scan(/mul\((\d+),(\d+)\)/)
  .flatten
  .map(&:to_i)
  .each_slice(2)
  .map { |(a,b)| a * b }
  .sum
