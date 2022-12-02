require './program.rb'
require 'pry'

class Part2 < Program::Solver
  def solution
    pulser.pulses && pulser.all_pulsed
  end
end

# Just use some sufficiently large number as input
# to find when all octopi pulse. Answer is 346
puts Part2.new(ARGV[0], 500).solution