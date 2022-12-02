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