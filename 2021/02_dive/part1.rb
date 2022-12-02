directions = File.open(ARGV[0], 'r', &:read).split(/\s/)
result = directions.each_slice(2).each_with_object({up: 0, down: 0, forward: 0}) { |mod, h| h[mod[0].to_sym] += mod[1].to_i }
puts (result[:down] - result[:up]) * result[:forward]
