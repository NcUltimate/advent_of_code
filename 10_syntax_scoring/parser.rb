class Program
  class Parser
    attr_reader :sequence, :missing, :error_idx
    def initialize(sequence)
      @sequence = sequence
      @missing = []
      @error_idx = -1
      parse!
    end

    def error
      error? ? @sequence[error_idx] : nil
    end

    def error?
      error_idx != -1
    end

    def incomplete?
      !error? && !@missing.empty?
    end

    private

    def parse!
      @missing = []
      @error_idx = -1
      i = 0
      until @error_idx != -1 or i == sequence.size
        case sequence[i]
        when '{'
          @missing.push('}')
        when '['
          @missing.push(']')
        when '('
          @missing.push(')')
        when '<'
          @missing.push('>')
        when '}'
          @error_idx = i if @missing[-1] != '}'
          @missing.pop
        when ']'
          @error_idx = i if @missing[-1] != ']'
          @missing.pop
        when ')'
          @error_idx = i if @missing[-1] != ')'
          @missing.pop
        when '>'
          @error_idx = i if @missing[-1] != '>'
          @missing.pop
        end
        i += 1
      end
    end

    def to_s
      sequence
    end
  end

  class Solver
    attr_reader :parsers
    def initialize(filename)
      @parsers =[]
      File.open(filename, 'r').readlines.each do |line|
        @parsers << Parser.new(line.chomp)
      end
    end
  end
end