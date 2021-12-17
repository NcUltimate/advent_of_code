require './program.rb'
require 'set'
require 'pry'

class Part2 < Program::Solver
  class BasinTraversal
    attr_reader :floor, :parents
    def initialize(floor)
      @floor = floor
      @parents = {}
      @basins = {}
    end

    def basins
      return @basins unless @basins.empty?

      visited = {}
      @parents = {}
      queue = floor.lows.dup
      queue.each do |xy|
        @parents[xy] = xy
      end

      while !queue.empty?
        xy = queue.shift
        visited[xy] = true
        neighbors = floor.neighbors08(xy[0], xy[1])
        neighbors.each do |nxy|
          next if visited[nxy]
          queue << nxy
          @parents[nxy] = @parents[xy]
        end
      end

      @parents.each do |xy,low_xy|
        @basins[low_xy] ||= Set.new
        @basins[low_xy] << xy
      end

      @basins
    end
  end

  def solution
    t = BasinTraversal.new(floor)
    t.basins.values.map(&:to_a).sort_by(&:size)[-3..-1].compact.map(&:size).reduce(&:*)
  end
end

class BasinVis
  attr_reader :floor, :basins
  def initialize(floor, basins)
    @floor = floor
    @basins = basins
  end

  def largest
    top_basins = basins.values.map(&:to_a).sort_by(&:size)[-3..-1].compact.flatten(1)
    visualize do |xy|
      top_basins.member?(xy)
    end
  end

  def all
    all_basins = basins.values.reduce(&:+)
    visualize do |xy|
      all_basins.member?(xy)
    end
  end

  private

  def visualize
    str = ""
    floor.cave.each_index do |row|
      floor.cave[row].each_index do |col|
        h = floor.height(row, col)
        if yield([row, col])
          str += "[#{h}]"
        else
          str += " #{h} "
        end
      end
      str += "\n"
    end
    print str
    str
  end
end

part2 = Part2.new(ARGV[0])
# basins = Part2::BasinTraversal.new(part2.floor).basins
# vis = BasinVis.new(part2.floor, basins)
# vis.largest
# puts "------"
# vis.all
# puts "------"
puts part2.solution