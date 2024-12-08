require 'set'

grid = File.open(ARGV[0], 'r', &:readlines)
  .map { |l| l.chomp.split('') }

l = Array.new(grid.length) { Array.new(grid[0].length) { Set.new } }

gs = grid.each_index.reduce([0,0]) { |g, r|
  grid[r].each_index.reduce(g) { |g2, c|
    '^>v<'.include?(grid[r][c]) ? [r,c] : g2
  }
}

os = grid[gs[0]][gs[1]]

def print_grid(grid)
  grid.each { |r| puts r.join(' ') }
end

def set2d(grid)
  Array.new(grid.length) { Array.new(grid[0].length) { Set.new } }
end

def iterate(grid, g, o, d = 0, pgrid = false)
  turn = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }

  gi,oi,isloop,b,visited,loopcache,selfencountered = g,o,false,[],set2d(grid),set2d(grid),false
  loop do
    selfencountered = d == 1 && pgrid[g[0]][g[1]] == 'x'
    grid[g[0]][g[1]] = 'x' 
    visited[g[0]][g[1]].add(o)

    break if loopcache[g[0]][g[1]].member?(o)

    nxt = [ 
      g[0] + ({ '^' => -1, 'v' => 1 }[o] || 0), 
      g[1] + ({ '<' => -1, '>' => 1 }[o] || 0), 
    ]   

    break if nxt[0] < 0 || nxt[1] < 0 || !grid[nxt[0]]&.[](nxt[1])

    if grid[nxt[0]][nxt[1]] == '#' 
      o = turn[o]
      return [[], [], false] if d == 1 && !selfencountered
    else
      dupgrid = grid.map(&:dup)
      dupgrid[nxt[0]][nxt[1]] = '#'

      if d == 0
        _, visitedc, isloopc = iterate(dupgrid, g, o, d + 1, grid)
        if isloopc
          b.push(nxt)
          visitedc.each_index { |vcr|
            visitedc[vcr].each_index { |vcc|
              loopcache[vcr][vcc] += visitedc[vcr][vcc]
            }
          }
        end
      end

      g = nxt
    end 

    if g == gi && o == oi
      isloop = true
      break
    end

    grid[g[0]][g[1]] = o 

    if d == 0
      puts
      print_grid(grid)
    end
  end 
  
  [b,visited,isloop]
end

b,v,l = iterate(grid, gs, os) 

v.each_index { |vr|
  puts v[vr].each_index.map { |vc|
    k = v[vr][vc]
    
    r = ' '
    n = k.member?('^')
    e = k.member?('>')
    s = k.member?('v')
    w = k.member?('<')

    if n & e & s & w
      r = '╋'
    elsif n & e & s
      r = '┣'
    elsif n & e & w
      r = '┻'
    elsif n & s & w
      r = '┫'
    elsif e & s & w
      r = '┳'
    elsif n & e
      r = '┏'
    elsif n & s
      r = '┋' 
    elsif n & w
      r = '┓'
    elsif e & s
      r = '┗'
    elsif e & w
      r = '┈'
    elsif s & w
      r = '┛'
    elsif n
      r = '^'
    elsif s
      r = 'v'
    elsif e
      r = '>'
    elsif w
      r = '<'
    end
    r
  }.join(' ')
}

b.each { |(r,c)| grid[r][c] = 'O' }

spacesvisited = grid.reduce(0) { |s, r|
  puts r.join(' ')
  s + r.count { |c| c !~ /[#\.]/ }
}
puts "#{spacesvisited} spaces visited"
puts "#{b.length} loop opportunities"
