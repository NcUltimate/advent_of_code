puts File.open(ARGV[0], 'r', &:readlines).map(&:chomp).reduce([[],0]) { |m, s| s == '' ? [m[0].push(m[1]),0] : [m[0], m[1] + s.to_i] }.first.sort.last(3).sum
