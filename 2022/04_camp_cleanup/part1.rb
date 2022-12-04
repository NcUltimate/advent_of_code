puts File.open(ARGV[0], 'r', &:readlines).map { |l| l.chomp.split(',').map { |r| Range.new(*r.split('-').map(&:to_i)).to_a } }.count { |l| [l[0].size, l[1].size].include?((l[0] & l[1]).size) }

