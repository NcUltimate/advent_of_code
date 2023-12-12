
lines_read = 0
directions = ''

starts = []

nodes = File.open(ARGV[0], 'r', &:readlines).reduce({}) do |nodes, line|
  lines_read += 1

  if lines_read == 1
    directions = line.chomp
    next nodes
  end

  node, l, r = line.scan(/\w+/)
  next nodes if node.nil?

  nodes[node] = { 'L' => l, 'R' => r }

  starts.push(node) if node[-1] == 'A'

  nodes
end

counts = {}
starts.each do |start|
  count = 0
  
  directions.chars.cycle.each do |direction|
    start = nodes[start][direction]
    count += 1
    break if start[-1] == 'Z'
  end

  counts[start] = count
end

p counts.reduce(1) { |lcm, x| lcm.lcm(x[1]) }