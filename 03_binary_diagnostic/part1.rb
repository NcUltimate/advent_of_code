a = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

b = a.map { |s| s.split(//) }

counts_01 = b.each_with_object({}) do |str, counts|
  str.each_with_index do |dig, idx|
    counts[idx] ||= [0, 0]
    counts[idx][0] += 1 if dig == "0"
    counts[idx][1] += 1 if dig == "1"
  end
end

gamma = ""
epsilon = ""
counts_01.each do |_, count|
  if count[1] - count[0] < 0
    gamma += "1"
    epsilon += "0"
  else
    gamma += "0"
    epsilon += "1"
  end
end

puts (gamma.to_i(2) * epsilon.to_i(2))