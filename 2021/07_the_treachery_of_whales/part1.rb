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
Sum all possible differences and find the min of sums.
=end

input = File.open(ARGV[0], 'r', &:read)
crabs = input.split(',').map(&:to_i)

min = nil
(0..crabs.max).each do |pos|
  fuel = crabs.reduce(0) do |sum, crab|
    sum + (crab - pos).abs
  end

  min = fuel if min.nil? || fuel < min
end

puts min