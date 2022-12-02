require 'active_support/all'
directions = File.open(ARGV[0], 'r', &:read).split(/\s/)

result = directions.each_slice(2).each_with_object({a: 0, d: 0, f: 0}) do |mod, h|
  if mod[0] == "down"
    h[:a] += mod[1].to_i
  elsif mod[0] == "up"
    h[:a] -= mod[1].to_i
  else
    h[:f] += mod[1].to_i
    h[:d] += mod[1].to_i * h[:a]
  end
end.slice(:d, :f).values.reduce(&:*)

puts result