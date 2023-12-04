require 'set'

input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

card_value = 0;

input.each_with_index do |line, idx|

  puts "---- #{idx}"
  rest_idx = line.index(/\d: /)
  rest = line[rest_idx + 3..-1]

  winning, actual = rest.split('|')
  
  winning = Set.new(winning.scan(/\d+/).map(&:to_i))
  actual = actual.scan(/\d+/).map(&:to_i)
  winners = actual.count { |num| winning.include?(num) }

  next unless winners > 0

  puts "#{idx + 1}: #{winners} #{2**(winners - 1)}"
  card_value += 2 ** (winners - 1)
end

puts card_value