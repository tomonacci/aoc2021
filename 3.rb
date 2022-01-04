def part1
  bits = $stdin.each_line.map(&:chomp).map(&:chars).transpose.map {|cs| cs.tally.to_a.min_by(&:last)[0].to_i }
  p bits.map {|b| 1 - b }.join.to_i(2) * bits.join.to_i(2)
end

def part2
  ss = $stdin.each_line.map(&:chomp)
  fas, fis = (0...ss.size).to_a, (0...ss.size).to_a
  for i in 0...ss[0].size
    cs = fas.map {|j| ss[j][i] }.tally
    #p cs
    b = cs.fetch(?1, 0) >= cs.fetch(?0, 0) ? ?1 : ?0
    fas = fas.select {|j| ss[j][i] == b }
    break if fas.size == 1
  end
  for i in 0...ss[0].size
    cs = fis.map {|j| ss[j][i] }.tally
    b = cs.fetch(?0, 0) <= cs.fetch(?1, 0) ? ?0 : ?1
    fis = fis.select {|j| ss[j][i] == b }
    break if fis.size == 1
  end
  #p ss[fas[0]].to_i(2)
  #p ss[fis[0]].to_i(2)
  p ss[fas[0]].to_i(2) * ss[fis[0]].to_i(2)
end

part1 # 3969000
#part2 # 4267809
