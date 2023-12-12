
lines_read = 0
directions = ''

nodes = File.open(ARGV[0], 'r', &:readlines).reduce({}) do |nodes, line|
  lines_read += 1

  if lines_read == 1
    directions = line.chomp
    next nodes
  end

  node, l, r = line.scan(/[A-Z]+/)
  next nodes if node.nil?

  nodes[node] = { 'L' => l, 'R' => r }

  nodes
end

start = 'AAA'
count = 0;
directions.chars.cycle.each do |direction|
  start = nodes[start][direction]
  count += 1
  break if start == 'ZZZ'
end

p count