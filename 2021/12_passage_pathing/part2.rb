require './program.rb'

class Program
  class PathFinder
    attr_reader :cave_system
    def initialize(cave_system)
      @cave_system = cave_system
    end

    def paths
      @paths ||= traverse(nil, Cave.start.name, Cave.start)
    end

    private

    def traverse(small_twice, caves, cave)
      if cave == Cave.final
        @paths ||= []
        return @paths << caves
      end

      connections = cave_system.connected_to(cave)
      connections&.each do |cave2|
        next if cave2.start?

        visits = caves.scan(cave2.name).size
        if cave2.small?
          if small_twice.nil? && visits == 1
            next traverse(cave2, "#{caves},#{cave2.name}", cave2)
          elsif small_twice == cave2
            next if visits >= 2
          else  
            next if visits >= 1
          end
        end
        
        traverse(small_twice, "#{caves},#{cave2.name}", cave2)
      end

      @paths
    end
  end

  class Part2 < Solver
    def solution
      PathFinder.new(cave_system).paths.size
    end
  end
end

puts Program::Part2.new(ARGV[0]).solution