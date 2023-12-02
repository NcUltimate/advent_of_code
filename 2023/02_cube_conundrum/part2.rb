input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

result = input.sum do |line|
  game_index = line.index(/: /)

  next 0 if !game_index

  game_num = line[/\d+/].to_i

  rest_idx = game_index + 2
  rest = line[rest_idx..-1]

  maxes = {
    'red' => -1,
    'green' => -1,
    'blue' => -1
  }

  rest.split('; ').each do |rounds|
    rounds.split(', ').each do |round|
      num = round[/\d+/].to_i
      color = round[/[a-zA-Z]+/]
      
      maxes[color] = [maxes[color], num].max
    end
  end

  maxes.values.reduce(&:*)
end

puts result