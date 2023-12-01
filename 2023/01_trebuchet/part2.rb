input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

map = {
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
  'zero': 0,
}

result = input.sum do |a|
  first = a.index(/\d/)
  firstVal = first ? a[first].to_i : -1
  last = a.rindex(/\d/)
  lastVal = last ? a[last].to_i : -1

  map.each do |k, v|
    newfirst = a.index(k.to_s)
    newlast = a.rindex(k.to_s)
    
    if newfirst && (!first || newfirst < first)
      first = newfirst
      firstVal = v
    end
    if newlast && (!last || newlast > last)
      last = newlast
      lastVal = v
    end
  end

  firstVal.to_i * 10 + lastVal.to_i
end

puts result