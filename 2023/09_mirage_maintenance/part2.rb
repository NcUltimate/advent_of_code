def expand(sequence, l = 1)
  if l == sequence.length
    return sequence
  end

  all_zero = true
  (0...sequence.length-l).map do |i|
    sequence[i] = sequence[i + 1] - sequence[i]
    all_zero &&= sequence[i] == 0
  end

  if !all_zero
    expand(sequence, l + 1)
  end

  sequence.sum
end

lines = File.open(ARGV[0], 'r', &:readlines)

result = lines.reduce(0) do |sum, line|
  sequence = line.chomp.split(' ').map(&:to_i)
  sum + expand(sequence.reverse)
end

p result