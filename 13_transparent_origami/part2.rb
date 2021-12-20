require './program.rb'
require 'pry'

class Program
  class Part2 < Solver
    def folded
      @folded ||= folds.reduce(folder) do |folder, line|
        folder.fold(line)
      end
    end

    def solution
      DotStringer.new(folded.dots).to_s
    end
  end
end

puts Program::Part2.new(ARGV[0]).solution