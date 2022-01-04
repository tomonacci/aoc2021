def enhance(iterations)
  padding = iterations + 10
  decoder = []
  loop do
    s = gets.chomp
    break if s.empty?
    s.chars.each {|s| decoder << (s == ?# ? 1 : 0) }
  end
  xss = []
  while s = gets&.chomp
    xs = Array.new(s.size + padding * 2, 0)
    s.chomp.chars.each_with_index {|s, i| xs[i+padding] = s == ?# ? 1 : 0 }
    xss << xs
  end
  n = xss[0].size
  m = xss.size + 2 * padding
  xss = [*padding.times.map { Array.new(n, 0) }, *xss, *padding.times.map { Array.new(n, 0) }]
  #puts xss.map {|xs| xs.map {|i| i.zero? ? ?. : ?# }.join }
  iterations.times do |t|
    yss = Array.new(m) { Array.new(n, 0) }
    for i in 1...m-1
      for j in 1...n-1
        bs = []
        for k in -1..1
          for l in -1..1
            #p [i+k, j+l, bs]
            bs << xss[i+k][j+l]
          end
        end
        yss[i][j] = decoder[bs.join.to_i(2)]
      end
    end
    xss = yss
    if t.odd?
      for i in [0, 1, -2, -1]
        for j in 0...n
          xss[i][j] = 0
        end
      end
      for i in 0...m
        for j in [0, 1, -2, -1]
          xss[i][j] = 0
        end
      end
    end
    #puts '-----'
    #puts xss.map {|xs| xs.map {|i| i.zero? ? ?. : ?# }.join } if t + 1 == iterations
    #p xss.flatten.sum
  end
  xss.flatten.sum
end

def part1
  p enhance(2)
end

def part2
  p enhance(50)
end

#part1
part2
