ntimes = (ARGV[1] || 100).to_i

r, c = (ARGV[2] ? ARGV[2].split('x').map(&:to_i) : [103, 101])

mr = r % 2 == 0 ? r / 2 - 1 : r / 2
mc = c % 2 == 0 ? c / 2 - 1 : c / 2

puts File.open(ARGV[0], 'r', &:readlines)
  .map { |l|
    l.scan(/(-?\d+,-?\d+)/).flatten.map { |j|
      j.split(',').map(&:to_i).reverse
    }.flatten
  }
  .map { |robot|
    [
      (robot[0] + (ntimes * robot[2])) % r,
      (robot[1] + (ntimes * robot[3])) % c
    ]
  }
  .group_by { |rr, rc|
    next 4 if rr > mr && rc > mc
    next 3 if rr > mr && rc < mc
    next 2 if rr < mr && rc > mc
    next 1 if rr < mr && rc < mc
    -1
  }
  .reduce(1) { |s, (k, v)| 
    next s if k == -1
    s * v.length
  }
