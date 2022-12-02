puts File.open(ARGV[0], 'r', &:readlines).sum { |r| {A: {X:4, Y:8, Z:3}, B: {X:1, Y:5, Z:9}, C: {X:7, Y:2, Z:6}}[r.chars[0].to_sym][r.chars[2].to_sym]}
