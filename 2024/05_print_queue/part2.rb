require 'tsort'

rules, arys = File.open(ARGV[0], 'r', &:readlines)
  .map(&:chomp)
  .reject(&:empty?)
  .partition { |l| l[/\|/] }
  .map { |ary| ary.map { |s| s.split(/\D/) } }

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

puts arys.reduce(0) { |sum, ary|
  correct = rules
    .select { |r| (r - ary).empty? }
    .each_with_object(Hash.new) { |(l, r), h|
      h[l] ||= []
      h[r] ||= []
      h[l].push(r)
    }
    .tsort
    .reverse

  sum + (correct === ary ? 0 : correct[correct.length / 2].to_i)
}
