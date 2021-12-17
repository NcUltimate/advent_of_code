require 'pry'

class Program
  class DigitID
    attr_reader :digit_map
    def initialize(seed)
      seed = seed.uniq
      @digit_map = {}

      _1 = seed.find { |s| s.size == 2 }
      @digit_map[_1] = 1

      _7 = seed.find { |s| s.size == 3 }
      @digit_map[_7] = 7

      _4 = seed.find { |s| s.size == 4 }
      @digit_map[_4] = 4

      _8 = seed.find { |s| s.size == 7 }
      @digit_map[_8] = 8

      _6 = seed.find do |s|
        s.size == 6 && _1.diff(s).size == 1
      end
      @digit_map[_6] = 6

      seg_tr = _1.diff(_6)
      seg_br = _1.diff(seg_tr)

      _2 = seed.find do |s|
        s.size == 5 && seg_br.diff(s).size == 1
      end
      @digit_map[_2] = 2

      _3 = seed.find do |s|
        s.size == 5 && _1.diff(s).size == 0
      end
      @digit_map[_3] = 3
      
      _5 = seed.find do |s|
        s.size == 5 && seg_tr.diff(s).size == 1
      end
      @digit_map[_5] = 5

      _9 = seed.find do |s|
        s.size == 6 && s.diff(_5).sequence == seg_tr.sequence
      end
      @digit_map[_9] = 9

      _0 = seed.find do |s|
        !@digit_map[s]
      end
      @digit_map[_0] = 0
    end

    def of(digit)
      digit_map[digit]
    end

    def to_i(digits)
      decimal_str = digits.reduce("") do |str, digit|
        str + digit_map[digit].to_s
      end

      decimal_str.to_i
    end

    def to_s
      digit_map.to_s
    end
    alias_method :inspect, :to_s
  end

  class Digit
    def self.scan(str)
      str.split(/\s+/).map do |digit|
        Digit.from(digit)
      end
    end

    def self.from(str)
      Digit.new(str.split(//))
    end

    attr_reader :sequence
    def initialize(sequence)
      @sequence = sequence.sort
    end

    def size
      sequence.size
    end

    def diff(other)
      Digit.new(sequence - other.sequence)
    end

    def to_s
      @to_s ||= sequence.join
    end

    def ==(other)
      to_s == other.to_s
    end

    def hash
      to_s.hash
    end

    alias_method :eql?, :==
    alias_method :inspect, :to_s
  end

  class Signal
    attr_reader :input, :output, :digit_id
    def initialize(signal)
      io = signal.split(/\s\|\s/)
      @input = Digit.scan(io[0])
      @output = Digit.scan(io[1])
      @digit_id = DigitID.new(@input)
    end

    def input_decimal
      @input_decimal ||= digit_id.to_i(input)
    end

    def output_decimal
      @output_decimal ||= digit_id.to_i(output)
    end

    def to_s
      @to_s ||= input.join(' ') + ' | ' + output.join(' ')
    end

    alias_method :inspect, :to_s
  end

  class Solver
    attr_reader :signals
    def initialize(filename)
      @signals = []
      File.open(filename, 'r').readlines.each do |line|
        @signals << Signal.new(line.chomp)
      end
    end

    def solution
      @solution ||= signals.reduce(0) do |sum, sig|
        sum + sig.output_decimal
      end
    end
  end
end

p = Program::Solver.new(ARGV[0])
puts p.solution
