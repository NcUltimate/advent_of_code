countmap = File.open(ARGV[0], 'r', &:read)
  .chomp
  .split(' ')
  .each_with_object(Hash.new { 0 }) { |n, o| o[n] = 1 }

ARGV[1].to_i.times { |k|
  zeroes = countmap['0']
  evendigs = countmap.keys.select { |k| k.length % 2 == 0 }
  othernums = countmap.keys.select { |k| k != '0' && k.length % 2 != 0 }

  newmap = Hash.new { 0 }
  newmap['1'] = zeroes if zeroes != 0

  evendigs.each { |dig|
    first = dig[0...dig.length/2].to_i.to_s
    second = dig[dig.length/2..-1].to_i.to_s

    newmap[first] ||= countmap[first]
    newmap[first] += countmap[dig]

    newmap[second] ||= countmap[second]
    newmap[second] += countmap[dig]
  }

  othernums.each { |other|
    other2024 = (other.to_i * 2024).to_s
    newmap[other2024] ||= countmap[other2024]
    newmap[other2024] += countmap[other]
  }

  countmap = newmap
}

p countmap.values.sum

