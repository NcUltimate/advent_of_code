a = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

# o2 generator rating
o2 = a.dup
i = 0
until o2.length == 1
  ones = o2.count { |s| s[i] == "1" }
  zeroes = o2.count { |s| s[i] == "0" }
  if zeroes > ones
    o2.reject! { |s| s[i] == "1" }
  else
    o2.reject! { |s| s[i] == "0" }
  end
  i += 1
end

# co2 scrubber rating
co2 = a.dup
i = 0
until co2.length == 1
  ones = co2.count { |s| s[i] == "1" }
  zeroes = co2.count { |s| s[i] == "0" }

  if ones < zeroes
    co2.reject! { |s| s[i] == "0" }
  else
    co2.reject! { |s| s[i] == "1" }
  end
  i += 1
end

puts o2[0].to_i(2) * co2[0].to_i(2)