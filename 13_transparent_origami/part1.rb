require './program.rb'

class Program
  class Part1 < Solver
    def solution
      folder.fold(folds.first).dots.size
    end
  end
end

puts Program::Part1.new(ARGV[0]).solution