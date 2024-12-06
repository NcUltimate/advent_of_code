parts = File.open(ARGV[0], 'r', &:readlines)
  .map(&:chomp)
  .reject(&:empty?)
  .partition { |l| l[/\|/] }

rules = Regexp.new(
  parts[0]
    .map { |r|
      f, s = r.split('|').reverse
      "(?:#{f}.*?(?=#{s}))"
    }
    .join('|')
)

page_sum = parts[1]
  .reject { |p| p =~ rules }
  .map { |p|
    n = p.split(',')
    n[n.length / 2].to_i
  }
  .sum

puts page_sum
