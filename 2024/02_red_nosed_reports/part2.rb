puts File.open(ARGV[0], 'r', &:readlines)
  .map { |l|
    r = l.split(/\s+/)
      .map(&:to_i)

    r.combination(r.length - 1)
  }
  .select { |l| 
    l.any? { |a|
      r = a.each_cons(2).map { |c| (c[1] - c[0]) }

      r.all? { |i| i >= 1 && i <= 3 } ||
        r.all? { |i| i >= -3 && i <= -1 }
    }
  }
  .length
