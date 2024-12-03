require 'set'

class PriorityQueue
  include Enumerable

  attr_reader :elements

  def initialize(elements = [])
    @elements = elements
  end

  def add(elem)
    index = @elements.bsearch_index do |x|
      x[:weight] > elem[:weight]
    end

    if index
      @elements.insert(index, elem)
    else
      @elements.push(elem)
    end
  end

  def pop
    @elements.shift
  end

  def each(&block)
    @elements.each(&block)
  end

  def empty?
    @elements.empty?
  end

  def size
    @elements.size
  end
end

class Crucible
  attr_reader :grid, :pqueue, :visited, :solution, :path
  def initialize(filename)
    @grid = File.open(ARGV[0], 'r', &:readlines)
      .map(&:chomp)
      .map { |l| l.chars.map(&:to_i) }

    @pqueue = PriorityQueue.new

    @visited = Array.new(@grid.length) { Array.new(@grid[0].length, 0) }
    @min_weight = Array.new(@grid.length) { Array.new(@grid[0].length, Float::INFINITY) }

    @path_grid = Array.new(@grid.length) { Array.new(@grid[0].length, '.') }
  end

  def distance(r, c)
    grid.length - r - 1 + grid[0].length - c - 1
  end

  def run!
    return @solution if @solution

    @pqueue.add({
      weight: 0,
      dist: distance(0,0),
      loc: [0, 0],
      steps: '',
    });

    iterations = 0
    while !@pqueue.empty?
      step = @pqueue.pop
      iterations += 1

      r, c = step[:loc]

      steps, weight = step[:steps], step[:weight]

      new_weight = weight + (r ==0 && c == 0 ? 0 : @grid[r][c])
      @min_weight[r][c] = [new_weight, @min_weight[r][c]].min

      next if @visited[r][c] > 1

      @visited[r][c] += 1


      if distance(r, c) == 0
        @solution = @min_weight[r][c]
        @path = steps
        break
      end

      if r < @grid.length - 1 && steps[-1] != 'N' && steps[-3..-1] != 'SSS'
        neighb_s = {
          weight: new_weight,
          loc: [r + 1, c],
          steps: steps + 'S',
        }
        @pqueue.add(neighb_s)
      end

      if c < @grid[0].length - 1 && steps[-1] != 'W' && steps[-3..-1] != 'EEE'
        neighb_e ={
          weight: new_weight,
          loc: [r, c + 1],
          steps: steps + 'E',
        }
        @pqueue.add(neighb_e)
      end

      if r > 0 && steps[-1] != 'S' && steps[-3..-1] != 'NNN'
        neighb_n = {
          weight: new_weight,
          loc: [r - 1, c],
          steps: steps + 'N',
        }
        @pqueue.add(neighb_n)
      end

      if c > 0 && steps[-1] != 'E' && steps[-3..-1] != 'WWW'
        neighb_w = {
          weight: new_weight,
          loc: [r, c - 1],
          steps: steps + 'W',
        }
        @pqueue.add(neighb_w)
      end
    end

    startr, startc = [0, 0]
    @path.chars.each do |dir|
      case dir
      when 'N'
        startr -= 1
      when 'S'
        startr += 1
      when 'E'
        startc += 1
      when 'W'
        startc -= 1
      end

      @path_grid[startr][startc] = '@'
    end

    puts "completed in #{iterations} iterations"
  end

  def print_visited
    puts "------"
    @visited.each do |row|
      puts row.map { |k| k == 0 ? '.' : k > 9 ? '*' : k }.join('')
    end
  end

  def print_min_weight
    puts "------"
    @min_weight.each do |row|
      puts row.map { |k| k == Float::INFINITY ? '∞' : k.to_s }.map { |k| k.ljust(3, ' ') }.join(' ')
    end
  end

  def print_path
    @path_grid.each do |row|
      puts row.join('')
    end
  end
end

crucible = Crucible.new(ARGV[0])

crucible.run!

puts crucible.solution
puts crucible.path
crucible.print_path
crucible.print_min_weight

