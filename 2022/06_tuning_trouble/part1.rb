 puts File.open(ARGV[0], 'r', &:readlines).map { |s| s.length.times.find { |i| s[i...i+4].chars.uniq.size === 4 } + 4 }
