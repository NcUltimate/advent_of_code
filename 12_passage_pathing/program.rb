require 'set'
require 'pry'

class Program
  class CaveSystem
    attr_reader :adjacency
    def initialize(paths)
      @adjacency ||= {}
      paths.each do |cave1, cave2|
        adjacency[cave1] ||= Set.new
        adjacency[cave2] ||= Set.new
        adjacency[cave1] << cave2
        adjacency[cave2] << cave1
      end
    end

    def connected_to(cave)
      adjacency[cave]
    end

    def [](cave)
      connected_to(cave)
    end
  end

  class Cave
    def self.start
      @start ||= new('start')
    end

    def self.final
      @final ||= new('end')
    end

    include Comparable

    attr_reader :name
    def initialize(name)
      @name = name
    end

    def big?
      @big ||= name == name.upcase
    end

    def small?
      !big?
    end

    def start?
      name == self.class.start.name
    end

    def end?
      name == self.class.final.name
    end

    def hash
      name.hash
    end

    def eql?(other)
      name.eql?(other.name)
    end

    def <=>(other)
      name.<=>(other.name)
    end

    def to_s
      name
    end

    alias_method :inspect, :to_s
  end

  class Solver
    attr_reader :paths
    def initialize(filename)
      @paths = File.open(filename, 'r', &:readlines).map do |l|
        l.chomp.split('-').map do |name|
          Cave.new(name)
        end
      end
    end

    def cave_system
      @cave_system ||= CaveSystem.new(paths)
    end
  end
end