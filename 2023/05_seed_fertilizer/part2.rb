input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

maps = []
seeds = []

map_idx = 0

def subrange(range, start, fin)
  return if start > fin
  return if start > range.end
  return if fin <= range.begin

  new_begin = range.begin
  new_end = range.end

  if range.include?(start)
    new_begin = start
  end

  if(range.include?(fin))
    new_end = fin
  end

  new_begin...new_end
end

def split_range(range, pinches = [])
  new_ranges = []
  pinches.unshift(-Float::INFINITY)
  pinches.push(Float::INFINITY)

  pinches.each_index do |idx|
    start = pinches[idx]
    fin = pinches[idx + 1]
    next unless fin

    subrange = subrange(range, start, fin)
    next unless subrange

    new_ranges.push(subrange)
  end
  new_ranges
end

def split_range_by_ranges(range, range_map)
  pinches = range_map.keys.reduce([]) do |acc, r|
    acc.push(r.begin)
    acc.push(r.end)
    acc
  end

  ranges = split_range(range, pinches.sort)
  
  ranges.map do |r|
    key = range_map.keys.find { |k| k.include?(r.begin) }
    offset = key ? range_map[key] : 0

    new_begin = r.begin + offset
    new_end = r.end + offset

    (new_begin...new_end)
  end
end


input.each do |line|
  if line =~ /seeds/
    seed_ranges = line.scan(/\d+/).map(&:to_i)
    seeds = seed_ranges.each_slice(2).map { |(s, e)| (s...s + e) }
  elsif line =~ /map/
    maps.push({})
  elsif line.strip.empty?
    next
  else
    dest, source, count = line.scan(/\d+/).map(&:to_i)
    maps[-1][source...source + count] = dest - source
  end
end

maps.each_with_index do |map, midx|
  new_seeds = []

  seeds.each do |seed|
    new_seeds += split_range_by_ranges(seed, map)
  end

  seeds = new_seeds
end

p seeds.min_by { |s| s.begin }.begin