puts File.open(ARGV[0], 'r', &:readlines).map(&:chomp).sum { |l| [-96, -38].map { |s| s + l[l.length/2..-1][/[#{l[0...l.length/2]}]/].ord }.find(&:positive?) }
