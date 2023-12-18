lines = File.open(ARGV[0], 'r', &:readlines)

boxes = Array.new(256) do
  {
    members: [],
    memo: {},
  }
end

lines.each do |line|
  line.chomp.split(',').each do |part|
    label, focal = part.split(/[=\-]/)

    box = label.chars.reduce(0) do |sum, let|
      sum += let.ord
      sum *= 17
      sum %= 256
    end

    current_pos_in_box = boxes[box][:memo][label]
    if part[/[=\-]/] == '='
      if current_pos_in_box
        boxes[box][:members][current_pos_in_box] = focal.to_i
      else
        boxes[box][:memo][label] = boxes[box][:members].length
        boxes[box][:members].push(focal.to_i)
      end
    elsif current_pos_in_box
      boxes[box][:memo].each do |k,v|
        if v > current_pos_in_box
          boxes[box][:memo][k] -= 1
        end
      end

      boxes[box][:members].delete_at(current_pos_in_box)
      boxes[box][:memo].delete(label)
    end
  end
end

power = boxes.each_index.reduce(0) do |sum, box|
  boxes[box][:members].each_with_index do |focal, order_within_box|
    sum += (box + 1) * focal * (order_within_box + 1)
  end

  sum
end

puts power