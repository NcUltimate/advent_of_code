input = File.open(ARGV[0], 'r', &:read)
  .chomp
  .split(' ')

ARGV[1].to_i.times { |k|
  evens = []
  input.reverse.each_index { |n|
    if input[n] == '0'
      input[n] = '1'
    elsif input[n].length % 2 == 0
      evens.push(n)
    else
      input[n] = "#{input[n].to_i * 2024}"
    end
  }

  evens.sort.reverse.each { |e|
    orig = input[e]
    input[e] = "#{orig[orig.length / 2..-1].to_i}"
    input.insert(e, "#{orig[0...orig.length / 2].to_i}")
  }

  puts input.join(' ')
}

puts input.length
