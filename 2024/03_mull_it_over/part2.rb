puts File.open(ARGV[0], 'r', &:read)
  .gsub("\n", '')
  .scan(/(?:^|do\(\)).*?(?:$|don't\(\))/)
  .flatten
  .map { |m|
    m.scan(/mul\((\d+),(\d+)\)+/)
      .flatten
      .map(&:to_i)
      .each_slice(2)
      .map { |(a,b)| a * b }
      .sum
  }
  .sum
