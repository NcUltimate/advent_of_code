require './parser.rb'

class Part2 < Program::Solver
  def solution
    scores = parsers.select(&:incomplete?).each_with_object([]) do |parser, ary|
      ary << parser.missing.reverse.reduce(0) do |sum, char|
        sum * 5 + case char
          when ')' then 1
          when ']' then 2
          when '}' then 3
          when '>' then 4
          else 0
          end
      end
    end

    scores.sort[scores.size / 2]
  end
end

puts Part2.new(ARGV[0]).solution