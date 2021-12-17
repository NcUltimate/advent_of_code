require './parser.rb'

class Part1 < Program::Solver
  def solution
    parsers.select(&:error?).reduce(0) do |sum, parser|
      sum + case parser.error
      when ')' then 3
      when ']' then 57
      when '}' then 1197
      when '>' then 25137
      else 0
      end
    end
  end
end

puts Part1.new(ARGV[0]).solution