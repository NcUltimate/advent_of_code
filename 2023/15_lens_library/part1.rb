lines = File.open(ARGV[0], 'r', &:readlines)

total = lines.reduce(0) do |whole_sum, line|
  line.chomp.split(',').each do |part|
    part_total = part.chars.reduce(0) do |sum, let|
      sum += let.ord
      sum *= 17
      sum %= 256
    end
    whole_sum += part_total
  end
  whole_sum
end

puts total