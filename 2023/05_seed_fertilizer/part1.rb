input = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

maps = []
seeds = []

p maps

map_idx = 0

input.each do |line|
  if line =~ /seeds/
    seeds = line.scan(/\d+/).map(&:to_i)
  elsif line =~ /map/
    maps.push({})
  elsif line.strip.empty?
    next
  else
    dest, source, count = line.scan(/\d+/).map(&:to_i)
    maps[-1][source..source + count] = (dest.. dest + count)
  end
end

locations = seeds.map do |seed|
  maps.each do |map|
    source_range =  map.keys.find { |r| r.include?(seed) }
    next if source_range.nil?
    
    offset = seed - source_range.begin
    dest = map[source_range].begin + offset

    seed = dest
  end
  seed
end

p locations.min