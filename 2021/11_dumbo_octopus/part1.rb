require './program.rb'
require 'pry'

class Part1 < Program::Solver
  def solution
    pulser.pulses
  end
end

puts Part1.new(ARGV[0], ARGV[1]).solution