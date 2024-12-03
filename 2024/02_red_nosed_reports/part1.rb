puts File.open(ARGV[0], 'r', &:readlines)
  .map { |l|
    l.split(/\s+/)
      .map(&:to_i)
      .each_cons(2)
      .map { |c| (c[1] - c[0]) }
  }
  .select { |l|
    l.all? { |i| i >=1 && i <= 3 } || l.all? { |i| i >= -3 && i <= -1 }
  }
  .length
