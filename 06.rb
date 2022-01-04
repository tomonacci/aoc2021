def simulate n
  timers = Array.new(9, 0)
  gets.split(/,/).each {|s| timers[s.to_i] += 1 }
  n.times do |i|
    timers[(i+7)%9] += timers[i%9]
  end
  puts timers.sum
end

def part1
  simulate 80
end

def part2
  simulate 256
end

part2
