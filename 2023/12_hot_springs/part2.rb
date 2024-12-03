def scan(str, counts)
  reg = counts.map { |c| "\#{#{c}}" }.join('\\.+')
  if str[0] != '.'
    reg = '\\.+' + reg
  end

  if str[-1] != '.'
    reg = reg + '\\.+'
  end

  reg = '^' + reg + '$'

  traverse(str, Regexp.new(reg))
end

def traverse(str, reg, pos = 0)
  count = 0

  if pos == str.length
    count += 1 if str =~ reg
  elsif str[pos] == '?'
    str2 = str.dup

    str2[pos] = '.'
    count += traverse(str2, reg, pos + 1)

    str2[pos] = '#'
    count += traverse(str2, reg, pos + 1)
  else
    count += traverse(str, reg, pos + 1)
  end

  count
end

lines = File.open(ARGV[0], 'r', &:readlines)
count = lines.reduce(0) do |sum, line|
  seq, counts = line.chomp.split(' ')
  sum + scan(seq, counts)
end

puts count