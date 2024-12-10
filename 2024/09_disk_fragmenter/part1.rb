stack = File.open(ARGV[0], 'r', &:read)
  .chomp
  .split('')
  .each_with_index
  .reduce([]) { |s, (n, i)|
    s.concat([i % 2 == 0 ? i/2 : '.'] * n.to_i)
  }

puts stack
  .each_index { |i|
    i < stack.length - 1 ? stack[i] = stack.pop : stack.pop while stack[i] == '.'
  }
  .each_with_index
  .reduce(0) { |s, (n,i)| s + n * i }

