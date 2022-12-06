 puts File.open(ARGV[0], 'r', &:readlines).map { |s| s.length.times.find { |i| s[i...i+14].chars.uniq.size === 14 } + 14 }
