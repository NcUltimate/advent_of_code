require './program.rb'

class Program
  class PathFinder
    attr_reader :cave_system
    def initialize(cave_system)
      @cave_system = cave_system
    end

    def paths
      @paths ||= traverse(Cave.start)
    end

    private

    def traverse(*caves)
      if caves.last == Cave.final
        @paths ||= []
        return @paths << caves.join(',')
      end

      connections = cave_system.connected_to(caves.last)
      connections&.each do |cave2|
        next if cave2.small? && caves.count(cave2).positive?

        traverse(*caves, cave2)
      end

      @paths
    end
  end

  class Part1 < Solver
    def solution
      PathFinder.new(cave_system).paths.size
    end
  end
end

puts Program::Part1.new(ARGV[0]).solution