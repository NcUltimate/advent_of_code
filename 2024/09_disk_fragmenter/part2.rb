require 'set'

stack = File.open(ARGV[0], 'r', &:read)
  .chomp
  .split('')
  .each_with_index
  .map { |n,i| [i % 2 == 0 ? i/2 : '.', n.to_i] }

considered = Set.new
loop do
  fidx = stack.each_index.find { |f|
    ridx = stack.length - f - 1
    next if considered.member?(stack[ridx][0])
    stack[ridx][0] != '.'
  }

  break unless fidx

  fidx = stack.length - fidx - 1
  file = stack[fidx]
  considered.add(file[0])

  sidx = stack.each_index.find { |s|
    next unless stack[s][0] == '.'
    stack[s][1] >= file[1]
  }

  next unless sidx

  space = stack[sidx]
  next if fidx < sidx

  ifile = file.dup
  stack[fidx][0] = '.'
  stack[sidx][1] -= file[1]
  stack.insert(sidx, ifile)
end

stack.reject! { |e| e[0] == '.' && e[1] == 0 }

puts stack.reduce([0,0]) { |(sum, i), e|
  next [sum, i + e[1]] if e[0] == '.'

  e[1].times { |k|
    sum += (e[0].to_i * (i + k))
  }

  [sum, i + e[1]]
}
