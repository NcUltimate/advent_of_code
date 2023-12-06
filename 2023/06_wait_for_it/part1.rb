puts File.open(ARGV[0], 'r', &:readlines)
  .map { |line| line.scan(/\d+/).map(&:to_i) }
  .transpose
  .map { |time, dist| (0..time).count { |t| (time - t) * t > dist } }
  .reduce(&:*)
