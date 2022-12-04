puts File.open(ARGV[0], 'r', &:readlines).map(&:chomp).each_slice(3).sum { |g| [-96, -38].map { |s| s + g.join('|')[/(.).*?\|.*?\1.*?\|.*?\1.*?/][0].ord }.find(&:positive?) }
