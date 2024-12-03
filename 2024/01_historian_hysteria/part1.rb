puts File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split(/\s+/) }
  .reject(&:empty?)
  .transpose
  .map { |l| l.map(&:to_i).sort }
  .transpose
  .map { |l| (l[1] - l[0]).abs }
  .sum
