puts File.open(ARGV[0], 'r', &:readlines).sum { |line| line.scan(/(\d+) (\w)/).reduce({r:0, g:0, b:0}) { |hash, (num, color)| hash.merge({color.to_sym => [hash[color.to_sym], num.to_i].max }) }.values.reduce(&:*) }