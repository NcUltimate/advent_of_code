File.open('input02.txt', 'r', &:readlines).map(&:to_i).each_cons(2).count { |a, b| b > a }
