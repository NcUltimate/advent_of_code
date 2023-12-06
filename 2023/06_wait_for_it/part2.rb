puts [File.open(ARGV[0], 'r', &:readlines).map { |line| line.scan(/\d+/).join.to_i }]
  .map { |time, dist| (0..time).count { |t| (time - t) * t > dist } }
  [0]