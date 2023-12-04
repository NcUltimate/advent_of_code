require 'set'

input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

winner_map = {}

input.each_with_index do |line, idx|
  rest_idx = line.index(/\d: /)
  rest = line[rest_idx + 3..-1]

  winning, actual = rest.split('|')
  
  winning = Set.new(winning.scan(/\d+/).map(&:to_i))
  actual = actual.scan(/\d+/).map(&:to_i)
  winners = actual.count { |num| winning.include?(num) }

  winner_map[idx + 1] = (idx + 2..idx + 1 + winners).to_a
end

winner_map.each do |card, winners|
  winners.each do |winner|
    puts "\"#{card}\" -> \"#{winner}\";"
  end
end

colors = %w[red orange yellow green blue indigo violet]

winner_map.keys.each do |card|
  # pick a random color and use style filled
  puts "\"#{card}\" [style=filled color=#{colors.sample}];"
end

cards_won = 0

q = (1..input.length).to_a

while q.length > 0
  card = q.shift
  cards_won += 1
  q.push(*winner_map[card]) if winner_map[card]
end

puts cards_won