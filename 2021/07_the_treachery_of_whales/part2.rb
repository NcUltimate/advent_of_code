=begin
# VISUAL
----------------|
-|
--|
|
----|
--|
-------|
-|
--|
--------------|

# SOLUTION
Sum all possible differences using integer sums
using the well known formula

(n - m) * (n - m + 1)/2

to sum the numbers m thru n.

=end

input = File.open(ARGV[0], 'r', &:read)
crabs = input.split(',').map(&:to_i)

min = nil
(0..crabs.max).each do |pos|
  fuel = crabs.reduce(0) do |sum, crab|
    cost = (crab - pos).abs
    sum + cost * (cost + 1) / 2
  end

  min = fuel if min.nil? || fuel < min
end

puts min