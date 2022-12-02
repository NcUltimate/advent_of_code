require './program.rb'

class Part1 < Program::Solver
  def solution
    @solution ||=
      floor.lows.reduce(floor.lows.size) do |sum, (x, y)|
        sum + floor.height(x, y)
      end
  end
end

puts Part1.new(ARGV[0]).solution