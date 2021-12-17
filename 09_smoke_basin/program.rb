class Program
  class CaveFloor
    attr_reader :cave
    def initialize(grid)
      @cave = grid
    end

    def width
      cave.size
    end

    def length
      cave[0].size
    end

    def height(x, y)
      cave[x][y]
    end

    def lows
      @lows ||= cave.each_index.reduce([]) do |lows, x|
        cave[x].each_index do |y|
          next unless neighbors(x, y).all? do |nx, ny|
            height(x, y) < height(nx, ny)
          end
          lows << [x, y]
        end
        lows
      end
    end

    def neighbors(x, y)
      neighbors = []
      neighbors << [x - 1, y] if x > 0
      neighbors << [x + 1, y] if x < width - 1
      neighbors << [x, y - 1] if y > 0
      neighbors << [x, y + 1] if y < length - 1
      neighbors
    end

    def neighbors08(x, y)
      neighbors(x,y).select do |nx, ny|
        height(nx, ny) < 9
      end
    end
  end

  class Solver
    attr_reader :floor
    def initialize(filename)
      input = File.open(filename, 'r', &:readlines)
      grid = input.map do |line|
        line.chomp.split(//).map(&:to_i)
      end
      @floor = CaveFloor.new(grid)
    end
  end
end