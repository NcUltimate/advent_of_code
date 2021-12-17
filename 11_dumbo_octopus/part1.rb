require 'set'
require 'pry'

class Program
  class Pulser
    attr_reader :octopi, :steps, :all_pulsed
    def initialize(octopi, steps)
      @octopi = octopi
      @steps = steps
      @all_pulsed = -1
      @done = false
    end

    def pulses
      return @pulses if @pulses

      @pulses = 0
      steps.times do |idx|
        nines = energize!
        @pulses += nines.size
        pulsed = Set.new
        ondeck = Set.new(nines)

        until nines.empty?
          octopus = nines.shift
          ondeck.delete(octopus)
          pulsed << octopus
          px, py = octopus

          octopi.neighbors(px, py).each do |neighbor|
            next if pulsed.member?(neighbor) ||
              ondeck.member?(neighbor)

            nx, ny = neighbor
            octopi[nx][ny] += 1
            next unless octopi[nx][ny] > 9

            nines << neighbor
            ondeck << neighbor
            @pulses += 1
          end
        end

        pulsed_count = deenergize!
        if pulsed_count == octopi.width * octopi.length
          @all_pulsed = idx + 1 if @all_pulsed == -1
        end
      end

      @pulses
    end

    private

    def energize!
      nines = []
      octopi.each_index do |row, col|
        octopi[row][col] += 1
        nines << [row, col] if octopi[row][col] > 9
      end
      nines
    end

    def deenergize!
      pulsed_count = 0
      octopi.each_index do |row, col|
        if octopi[row][col] > 9
          octopi[row][col] = 0
          pulsed_count += 1
        end
      end
      pulsed_count
    end
  end

  class Octopi
    attr_reader :octopi
    def initialize(octopi)
      @octopi = octopi
    end

    def width
      octopi.size
    end

    def length
      octopi[0].size
    end

    def each_index(&block)
      octopi.each_index do |row|
        octopi[row].each_index do |col|
          yield(row, col)
        end
      end
    end

    def [](row)
      octopi[row]
    end

    def neighbors(x, y)
      neighbors = []
      (-1..1).each do |ox|
        (-1..1).each do |oy|
          nx = x + ox
          next if nx < 0 || nx > width - 1

          ny = y + oy
          next if ny < 0 || ny > length - 1

          neighbors << [nx, ny]
        end
      end
      neighbors
    end

    def to_s(x = nil, y = nil)
      str = ""
      octopi.each_index do |row|
        octopi[row].each_index do |col|
          if x != nil && y != nil && row == x && col == y
            str += "(#{octopi[row][col]})".center(6)
          elsif octopi[row][col] == 0
            str += "[#{octopi[row][col]}]".center(6)
          else
            str += "#{octopi[row][col]}".center(6)
          end
        end
        str += "\n"
      end
      str
    end
  end

  class Solver
    attr_reader :pulser
    def initialize(filename, steps)
      input = File.open(filename, 'r', &:readlines).map do |l|
        l.chomp.split(//).map(&:to_i)
      end
      @pulser = Pulser.new(Octopi.new(input), steps.to_i)
    end

    def solution
      pulser.pulses
    end
  end
end

# Just use some sufficiently large number as input to find when 
# all octopi pulse. Answer is 346
part1 = Program::Solver.new(ARGV[0], ARGV[1])
solution = part1.solution
puts part1.pulser.octopi
puts part1.pulser.all_pulsed
puts solution