puts File.open(ARGV[0], 'r', &:readlines).map(&:chomp).reduce([0,0]) { |m, s| s == '' ? [m.max,0] : [m[0], m[1] + s.to_i] }.first
