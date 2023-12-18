lines = File.open(ARGV[0], 'r', &:readlines)

@grid = lines.map { |line| line.chomp.chars }

@visited = Array.new(@grid.size) do
  Array.new(@grid[0].size) do
    { 'N' => false, 'E' => false, 'S' => false, 'W' => false }
  end
end

def debug
  debug = @grid.map(&:dup)

  debug.each_index do |r|
    debug[r].each_index do |c|
      dirs = @visited[r][c]

      if dirs['N'] && dirs['S'] && dirs['E'] && dirs['W']
        debug[r][c] = '+'
      elsif dirs['N'] && dirs['S'] && dirs['E']
        debug[r][c] = '├'
      elsif dirs['N'] && dirs['S'] && dirs['W']
        debug[r][c] = '┤'
      elsif dirs['N'] && dirs['E'] && dirs['W']
        debug[r][c] = '┴'
      elsif dirs['S'] && dirs['E'] && dirs['W']
        debug[r][c] = '┬'
      elsif dirs['N'] || dirs['S']
        debug[r][c] = '│'
      elsif dirs['E'] || dirs['W']
        debug[r][c] = '─'
      elsif dirs['N'] && dirs['E']
        debug[r][c] = '└'
      elsif dirs['N'] && dirs['W']
        debug[r][c] = '┘'
      elsif dirs['S'] && dirs['E']
        debug[r][c] = '┌'
      elsif dirs['S'] && dirs['W']
        debug[r][c] = '┐'
      else
        debug[r][c] = '.'
      end
    end
  end

  debug.each { |line| puts line.join }
  puts
end

def trace_beam(r = 0, c = 0, dir = 'E')
  return if dir == 'E' && c > @grid[0].length - 1
  return if dir == 'W' && c < 0
  return if dir == 'N' && r < 0
  return if dir == 'S' && r > @grid.length - 1

  return if @visited[r][c][dir]

  @visited[r][c][dir] = true

  case dir
  when 'N'
    if @grid[r][c] == '.' || @grid[r][c] == '|'
      trace_beam(r - 1, c, dir)
    elsif @grid[r][c] == '-'
      trace_beam(r, c - 1, 'W')
      trace_beam(r, c + 1, 'E')
    elsif @grid[r][c] == '/'
      trace_beam(r, c + 1, 'E')
    elsif @grid[r][c] == '\\'
      trace_beam(r, c - 1, 'W')
    end
  when 'E'
    if @grid[r][c] == '.' || @grid[r][c] == '-'
      trace_beam(r, c + 1, dir)
    elsif @grid[r][c] == '|'
      trace_beam(r - 1, c, 'N')
      trace_beam(r + 1, c, 'S')
    elsif @grid[r][c] == '/'
      trace_beam(r - 1, c, 'N')
    elsif @grid[r][c] == '\\'
      trace_beam(r + 1, c, 'S')
    end
  when 'S'
    if @grid[r][c] == '.' || @grid[r][c] == '|'
      trace_beam(r + 1, c, dir)
    elsif @grid[r][c] == '-'
      trace_beam(r, c - 1, 'W')
      trace_beam(r, c + 1, 'E')
    elsif @grid[r][c] == '/'
      trace_beam(r, c - 1, 'W')
    elsif @grid[r][c] == '\\'
      trace_beam(r, c + 1, 'E')
    end
  when 'W'
    if @grid[r][c] == '.' || @grid[r][c] == '-'
      trace_beam(r, c - 1, dir)
    elsif @grid[r][c] == '|'
      trace_beam(r - 1, c, 'N')
      trace_beam(r + 1, c, 'S')
    elsif @grid[r][c] == '/'
      trace_beam(r + 1, c, 'S')
    elsif @grid[r][c] == '\\'
      trace_beam(r - 1, c, 'N')
    end
  end
end

trace_beam


p @visited.flatten(2).reduce(0) { |s, v| s + (v.values.any? ? 1 : 0) }