stack = File.open(ARGV[0], 'r', &:read)
  .chomp
  .split('')
  .each_with_index
  .map { |n,i| [i % 2 == 0 ? i/2 : '.', n.to_i] }

orig = stack.dup
#p orig

=begin
previous answers:
6347440242959

=end

l,r,n = 1,stack.length - 1,0
while l != -1 && r > 0 && l - n <= r
  #puts
  #puts "------ #{l}  ----- #{r} (#{orig[r]}) ----- #{n} -----------"
  i = l
  if stack[i][1] < orig[r][1]
    i += 1 while i - n <= r && (stack[i][0] != '.' || stack[i][1] < orig[r][1])
  end

  #puts "STACK #{i} #{r} #{stack}"
  next r -= 2 if i - n > r

  if orig[r][1] <= stack[i][1]
    #puts "Moving #{i} (#{stack[i]}) <-- #{r} (#{orig[r]})"
    full = orig[r][1] == stack[i][1]
    if full
      if i == l
        l = stack.each_index.find { |k| k > l && stack[k][0] == '.' }
        #puts "RESETTING l TO #{l}"
      end
    else
      stack.insert(i + 1, ['.', stack[i][1] - orig[r][1]])
      n += 1
      l += 1 if i == l
    end

    stack[i] = orig[r].dup
    orig[r][0] = '.'
  end

  r -= 2
end

puts "FINAL: #{l} #{r}"

puts stack.reduce([0,0,'']) { |(sum, i, str), e|
  #puts "#{sum} #{i} #{e}"
  next [sum, i + e[1], str + ('.' * e[1])] if e[0] == '.' 

  e[1].times { |k|
    amt = (e[0].to_i * (i + k))
    #puts "   adding #{amt}"
    sum += amt
  }

  [sum, i + e[1], str + e[0].to_s * e[1]]
}

p stack
