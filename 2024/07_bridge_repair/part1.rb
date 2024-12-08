eqs = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.scan(/\d+/).map(&:to_i) }

def solvable(eq, r = eq[1], d = 2)
  return r == eq[0] if d == eq.length
  return false if r > eq[0]

  plus = solvable(eq, r + eq[d], d + 1)
  return plus if plus

  return solvable(eq, r * eq[d], d + 1)
end

puts eqs.reduce(0) { |sum, eq|
  solvable(eq) ? sum + eq[0] : sum
}
