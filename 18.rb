require 'json'

def linearize(n)
  n.is_a?(Array) ? [:left, *n.flat_map {|m| linearize(m) }, :right] : [n]
end

def pairify(ss)
  stack = []
  ss.each do |s|
    case s
    when :right
      r = stack.pop
      l = stack.pop
      stack.pop # :left
      stack << [l, r]
    else
      stack << s
    end
  end
  stack.pop
end

def reduce(l)
  loop do
    changed = false
    depth = 0
    for i in 0...l.size
      case l[i]
      when :left
        depth += 1
      when :right
        depth -= 1
      else
        if depth > 4 && l[i+1].is_a?(Integer)
          ll = l[0...i-1].reverse
          lli = ll.find_index {|x| x.is_a?(Integer) }
          ll[lli] += l[i] if lli
          lr = l[i+3..-1]
          lri = lr.find_index {|x| x.is_a?(Integer) }
          lr[lri] += l[i+1] if lri
          l = ll.reverse + [0] + lr
          changed = true
          break
        end
      end
    end
    next if changed
    for i in 0...l.size
      if l[i].is_a?(Integer) && l[i] >= 10
        l = l[0...i] + [:left, l[i] / 2, (l[i] + 1) / 2, :right] + l[i+1..-1]
        changed = true
        break
      end
    end
    break unless changed
  end
  l
end

def magnitude(n)
  n.is_a?(Array) ? 3 * magnitude(n[0]) + 2 * magnitude(n[1]) : n
end

def add(a, b)
  #puts '-----'
  l = linearize([a, b])
  #p pairify(l)
  l = reduce(l)
  #p pairify(l)
  pairify(l)
end

def read_numbers
  $stdin.each_line.map {|s| JSON.parse(s) }
end

def part1
  p magnitude(read_numbers.reduce {|a, b| add(a, b) })
end

def part2
  p read_numbers.permutation(2).map {|a, b| magnitude(add(a, b)) }.max
end

#part1
part2
