lines = File.open(ARGV[0], 'r', &:readlines).map(&:chomp)

nums = lines[0].split(/,/)

boards = lines[2..-1].map(&:strip).map { |l| l.split(/\s+/) }.reject(&:empty?).each_slice(5).to_a

bcells = boards.each_with_index.each_with_object({}) do |(board, bidx), bcells|
  bcells[bidx] = board.each_with_index.each_with_object({}) do |(row, ridx), nmap|
    row.each_with_index do |num, cidx|
      nmap[num] = [ridx, cidx]
    end
  end
end

last_num = nil
winners = {}
stop_at_first_winner = ARGV[1].nil?
result = nums.each_with_object({}) do |num, result|
  next if !winners.empty? && stop_at_first_winner

  last_num = num
  bcells.each do |bidx, nmap|
    next if nmap[num].nil?
    next if winners[bidx]
    next if !winners.empty? && stop_at_first_winner

    result[bidx] ||= { row: {}, col: {}, marked: []}
    result[bidx][:row][nmap[num][0]] ||= 0
    result[bidx][:col][nmap[num][1]] ||= 0
    result[bidx][:row][nmap[num][0]] += 1
    result[bidx][:col][nmap[num][1]] += 1
    result[bidx][:marked] << num

    if result[bidx][:row][nmap[num][0]] == 5
      winners[bidx] = num
    elsif result[bidx][:col][nmap[num][1]] == 5
      winners[bidx] = num
    end
  end
end

last_winner = winners.keys.last
unmarked_sum = bcells[last_winner].keys.reduce(0) do |sum, num|
  next sum if result[last_winner][:marked].include?(num)

  sum + num.to_i
end

puts unmarked_sum * winners.values.last.to_i