require 'pry'

if ARGV.size < 1
  puts "Usage: ruby part1.rb [FILENAME] [[DAYS]]"
  puts "   FILENAME: name of the input file"
  puts "   DAYS: integer number of days, default 10"
  exit
end

input = File.open(ARGV[0], 'r', &:read)
fish = input.split(',').map(&:to_i)

# zero_days keeps track of when new fish spawn.
zero_days = [0,0,0,0,0,0,0]
fish.each do |fish|
  zero_days[fish + 1] += 1
end

# hatchlings keeps track of newly spawned fish,
# which do not spawn fish immediately.
hatchlings = [0,0,0,0,0,0,0]

num_days = (ARGV[1] || 10).to_i

rz = [zero_days.dup]
rh = [hatchlings.dup]
(num_days + 1).times do |day|
  # 1. Update number of fish
  mod_day = day % 7
  prev_mod_day = (day - 1) % 7

  # 2. Update hatchlings
  next_zero_day = (mod_day + 9) % 7
  hatchlings[next_zero_day] += zero_days[mod_day]

  # 3. Hatch hatchlings that are ready
  zero_days[prev_mod_day] += hatchlings[prev_mod_day]
  hatchlings[prev_mod_day] = 0
  rz << zero_days.dup
  rh << hatchlings.dup
end

puts zero_days.reduce(&:+) + hatchlings.reduce(&:+)

=begin
         0 1 2 3 4 5 6 0 1 2 3 4 5 6
00 | 0 | 0 0 0 0 0 0 0 0 1 1
01 | 1 | 0 0 0 0 0 0 0 0 0 0
02 | 2 | 1 1 1 1 1 1 1 1 1 1
03 | 3 | 1 1 1 1 1 1 1 1 1 1
04 | 4 | 2 2 2 2 2 3 3 3 3 3
05 | 5 | 1 1 1 1 1 1 2 2 2 2
06 | 6 | 0 0 0 0 0 0 0 2 2 2
------------------------------
|        5 5 6 7 9 A A A A B C
------------------------------
07 | 0 | 0 0 0 0 0 1 1 1 0 0
08 | 1 | 0 0 0 0 0 0 0 0 0 0
09 | 2 | 0 0 0 0 0 0 0 0 0 0
10 | 3 | 0 0 0 0 0 0 0 0 0 0
11 | 4 | 0 0 1 1 1 0 0 0 0 1
12 | 5 | 0 0 0 1 1 1 0 0 0 0
13 | 6 | 0 0 0 0 2 2 2 0 0 0


# test output function
puts "            0   1   2   3   4   5   6"
puts "_____________________________________"
rz.each_with_index do |day, idx|
  str = day.reduce("") do |s, d|
    s + d.to_s.rjust(6, ' ')
  end
  puts "#{idx.to_s.rjust(2, '0')} | #{idx % 7} | #{str}"
end
=end