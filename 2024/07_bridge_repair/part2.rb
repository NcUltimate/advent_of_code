eqs = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.scan(/\d+/).map(&:to_i) }

def solvable(eq, r = eq[1], d = 2, ops = [])
  if d == eq.length
    if r == eq[0]
      r2 = eq[1...d].zip(ops)
        .flatten
        .compact
        .join(' ')

      puts "#{' ' * d}#{r} = #{r2}"
    end
    return r == eq[0]
  end

  if r > eq[0]
    return false
  end

  plus = solvable(eq, r + eq[d], d + 1, ops + ['+'])
  return plus if plus

  mul = solvable(eq, r * eq[d], d + 1, ops + ['*'])
  return mul if mul

  mul = solvable(eq, "#{r}#{eq[d]}".to_i, d + 1, ops + ['||'])
  return mul if mul
end

puts eqs.reduce(0) { |sum, eq|
  solvable(eq) ? sum + eq[0] : sum
}
