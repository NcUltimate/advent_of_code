puts File.open(ARGV[0], 'r', &:readlines).map(&:chomp).sum { |a| a[a.index(/\d/)].to_i * 10 + a[a.rindex(/\d/)].to_i }