puts File.open(ARGV[0], 'r', &:readlines).map(&:to_i).each_cons(3).map { |a| a.reduce(&:+) }.each_cons(2).count { |a, b| b > a }
