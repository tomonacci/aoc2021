def part1
  #ps, ss = [3, 7], [0, 0]
  ps, ss = [2, 6], [0, 0]
  (0..Float::INFINITY).lazy.map {|i| i % 100 + 1 }.each_slice(3).map(&:sum).with_index.each do |x, i|
    ps[i%2] += x
    ps[i%2] %= 10
    ss[i%2] += ps[i%2] + 1
    if ss[i%2] >= 1000
      p ss[(i+1)%2] * (i + 1) * 3
      break
    end
  end
end

def part2
  moves = (1..3).map {|i| (1..3).map {|j| (1..3).map {|k| i+j+k } } }.flatten.sort.group_by(&:itself).transform_values(&:size)
  #p moves
  #dp[s1][s2][t][p1][p2]
  dp = Array.new(31) { Array.new(31) { Array.new(2) { Array.new(10) { Array.new(10, 0) } } } }
  #dp[0][0][0][3][7] = 1
  dp[0][0][0][2][6] = 1
  for s1s2 in 0..40
    for s1 in 0..s1s2
      s2 = s1s2 - s1
      next unless s1 <= 20 && s2 <= 20
      for t in 0..1
        for p1 in 0..9
          for p2 in 0..9
            next unless dp[s1][s2][t][p1][p2] > 0
            moves.each do |d, c|
              p1d, p2d = t.zero? ? [d, 0] : [0, d]
              p1n, p2n = (p1+p1d) % 10, (p2+p2d) % 10
              s1d, s2d = t.zero? ? [p1n + 1, 0] : [0, p2n + 1]
              s1n, s2n = s1+s1d, s2+s2d
              dp[s1n][s2n][1-t][p1n][p2n] += dp[s1][s2][t][p1][p2] * c
              #p [s1n,s2n,1-t,p1n,p2n], dp[s1n][s2n][1-t][p1n][p2n]
            end
          end
        end
      end
    end
  end
  us = [0, 0]
  for s1 in 0..30
    for s2 in 0..30
      for t in 0..1
        for p1 in 0..9
          for p2 in 0..9
            us[t] += dp[s1][s2][t][p1][p2] if s1 >= 21 || s2 >= 21
          end
        end
      end
    end
  end
  p us.max
end

#part1 # 1006866
part2
