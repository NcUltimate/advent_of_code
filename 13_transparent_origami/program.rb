require 'set'

class Program
  class DotStringer
    attr_reader :dots
    def initialize(dots)
      @dots = dots
    end

    def to_s
      @to_s ||= begin
        height.times.reduce('') do |grid_str, y|
          grid_str + width.times.each.reduce('') do |str, x|
            next str + ' ' unless grid[x]
            str + (grid[x][y] ?  '#' : ' ')
          end + "\n"
        end
      end
    end
    alias_method :inspect, :to_s

    private

    def width
      @width ||= dots.max_by(&:x)&.x + 1
    end

    def height
      @height ||= dots.max_by(&:y)&.y + 1
    end

    def grid
      @grid ||= dots.each_with_object({}) do |dot, grid|
        grid[dot.x] ||= {}
        grid[dot.x][dot.y] = dot
      end
    end
  end

  class DotFolder
    attr_reader :dots
    def initialize(dots)
      @dots = dots
    end

    def fold(line)
      folded = dots.each_with_object([])do |dot, folded|
        if dot > line
          folded << dot.fold(line)
        else
          folded << dot
        end
      end

      DotFolder.new(folded.uniq)
    end

    def to_s
      @to_s ||= begin
        width = dots.max_by(&:x).x
        height = dots.max_by(&:y).y

        (0..height).reduce('') do |grid_str, y|
          grid_str + (0..width).each.reduce('') do |str, x|
            str + (grid_map[x] && grid_map[x][y] ?  '#' : ' ')
          end + "\n"
        end
      end
    end
    alias_method :inspect, :to_s
  end

  class Dot
    include Comparable

    attr_reader :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end

    def to_a
      @to_a ||= [x,y]
    end

    def hash
      to_s.hash
    end

    def eql?(other)
      to_s.eql?(other.to_s)
    end

    def fold(other)
      if other.x.zero?
        Dot.new(x, 2 * other.y - y)
      elsif other.y.zero?
        Dot.new(2 * other.x - x, y)
      else
        self
      end
    end

    def <=>(other)
      if other.x.zero?
        y.<=>(other.y)
      elsif other.y.zero?
        x.<=>(other.x)
      else
        to_s.<=>(other.to_s)
      end
    end

    def to_s
      @to_s ||= "(#{x},#{y})"
    end

    alias_method :inspect, :to_s
  end

  class Solver
    attr_reader :dots, :folds
    def initialize(filename)
      dot_mode = true
      @dots = []
      @folds = []
      File.open(filename, 'r', &:readlines).each do |l|
        if l.chomp.empty?
          dot_mode = false
        elsif dot_mode
          @dots << Dot.new(*l.chomp.split(',').map(&:to_i))
        else
          m = l.chomp.match(/(x|y)=(\d+)$/)
          if m[1] == 'x'
            @folds << Dot.new(m[2].to_i, 0)
          else
            @folds << Dot.new(0, m[2].to_i)
          end
        end
      end
    end

    def folder
      @folder ||= DotFolder.new(dots)
    end
  end
end