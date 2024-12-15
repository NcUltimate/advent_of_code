is_part2 = !!ARGV[1]

MACHINES = File.open(ARGV[0], 'r', &:readlines)
  .each_slice(4)
  .map { |rules|
    rules.map { |r|
      r.scan(/(\d+)/)
        .flatten
        .map(&:to_i)
    }.reject(&:empty?)
  }
  .map { |rule|
    a, b = rule.transpose
    a[2] += is_part2 ? 10000000000000 : 0
    b[2] += is_part2 ? 10000000000000 : 0

    ca = Rational(a[2], a[1])
    ma = Rational(-a[0], a[1])

    cb = Rational(b[2], b[1])
    mb = Rational(-b[0], b[1])

    x = (ca - cb) / (mb - ma)
    y = (a[2] - a[0] * x) / a[1]
    [x, y]
  }
  .select { |r|
    r[0].denominator == 1 && r[1].denominator == 1
  }

tokens = MACHINES
  .reduce(0) { |s, r|
    s + 3 * r[0] + r[1]
  }
  .to_i

puts tokens
