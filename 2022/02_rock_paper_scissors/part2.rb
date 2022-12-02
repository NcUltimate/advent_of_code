puts File.open(ARGV[0], 'r', &:readlines).sum { |r| {A: {X:3, Y:4, Z:8}, B: {X:1, Y:5, Z:9}, C: {X:2, Y:6, Z:7}}[r.chars[0].to_sym][r.chars[2].to_sym]}
