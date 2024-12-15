require 'set'

ntimes = (ARGV[1] || 100).to_i

r, c = (ARGV[2] ? ARGV[2].split('x').map(&:to_i) : [103, 101])

mr = r % 2 == 0 ? r / 2 - 1 : r / 2
mc = c % 2 == 0 ? c / 2 - 1 : c / 2

robots = File.open(ARGV[0], 'r', &:readlines)
  .map { |l|
    l.scan(/(-?\d+,-?\d+)/).flatten.map { |j|
      j.split(',').map(&:to_i).reverse
    }.flatten
  }

minavgdist = Float::INFINITY
robcache = Set.new
n = 0
loop do
  if n % 1000 == 0
    puts "Looping #{n}..."
  end

  robs = robots.map { |robot|
    [
      (robot[0] + (n * robot[2])) % r,
      (robot[1] + (n * robot[3])) % c
    ]
  }

  robstr = robs.reduce('') { |rs, rob| rs + "(#{rob[0]},#{rob[1]})" }
  if robcache.member?(robstr)
    puts "@@@@@@@@@@ ROBCACHE HIT #{n} @@@@@@@@@@@"
    break
  end

  robcache.add(robstr)

  # ugh
  dists = []
  robs.each_index { |r1|
    robs.each_index { |r2|
      next if r2 == r1
      dists.push(
        Math.sqrt((robs[r2][1] - robs[r1][1]) ** 2 + (robs[r2][0] - robs[r1][0]) ** 2)
      )
    }
  }
  avgdist = dists.sum / dists.length

  if avgdist < minavgdist
    grid = Array.new(r) { Array.new(c) { '.' } }
    robs.each { |rr, rc|
      grid[rr][rc] = '@'
    }

    puts "------------------ #{n} #{avgdist}-----------------------"
    grid.each { |g| puts g.join(' ') }
    puts
    minavgdist = avgdist
  end
  n += 1
end
