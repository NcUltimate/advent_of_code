input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

result = input.sum do |line|
  game_index = line.index(/: /)

  next if !game_index

  game_num = line[/\d+/].to_i

  rest_idx = game_index + 2
  rest = line[rest_idx..-1]

  possible = true
  rest.split('; ').each do |rounds|
    next unless possible 
    rounds.split(', ').each do |round|
      next unless possible 

      num = round[/\d+/].to_i
      color = round[/[a-zA-Z]+/]
      
      if color == 'red'
        possible = num <= 12
      elsif color == 'green'
        possible = num <= 13
      elsif color == 'blue'
        possible = num <= 14
      else
        possible = false
      end
    end
  end

  puts game_num if possible
  possible ? game_num : 0
end

puts result