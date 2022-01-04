require 'matrix'
require 'set'

def part1
  cs = [1, 0, -1, 0]
  ss = [0, 1, 0, -1]
  rotate = 3.times.map do |a|
    4.times.map do |r|
      m = [
        [1, 0, 0],
        [0, cs[r], -ss[r]],
        [0, ss[r], cs[r]],
      ]
      Matrix.build(4, 4) do |i, j|
        if i < 3 && j < 3
          m[(i+3-a)%3][(j+3-a)%3]
        elsif i == 3 && j == 3
          1
        else
          0
        end
      end
    end
  end
  os = [
    [0, 0],
    [1, 0],
    [2, 0],
    [3, 0],
    [0, 1],
    [0, 3],
  ].flat_map {|yaw, pitch|
    4.times.map {|roll|
      rotate[2][yaw] * rotate[1][pitch] * rotate[0][roll]
    }
  }
  #puts os
  coords = []
  $stdin.each_line do |l|
    case l
    when /--- scanner \d+ ---/
      coords << Set.new
    when /(-?\d+),(-?\d+),(-?\d+)/
      coords.last << Vector[*[$1, $2, $3].map(&:to_i), 1]
    end
  end
  n = coords.size
  ts = Array.new(n)
  ts[0] = rotate[0][0]
  q = [0]
  until q.empty?
    a = q.shift
    n.times do |b|
      next if a == b || ts[b]
      puts "Examining #{a} -> #{b}"
      t_ab = os.lazy.flat_map {|o| coords[a].lazy.flat_map {|v| coords[b].lazy.map {|w| o + (Matrix.build(4, 3) { 0 }.hstack(v - o * w)) } } }.find {|t|
        #coords[b].count {|z| coords[a].member?(t * z) } >= 12
        ct, cf, r = 0, 0, false
        for z in coords[b]
          if coords[a].member?(t * z)
            ct += 1
          else
            cf += 1
          end
          if ct >= 12
            r = true
            break
          elsif coords[b].size - cf < 12
            break
          end
        end
        r
      }
      if t_ab
        puts "Found #{a} -> #{b}"
        ts[b] = ts[a] * t_ab
        q << b
      end
    end
  end
  puts n.times.flat_map {|a|
    coords[a].map {|v|
      ts[a] * v
    }
  }.uniq.size
end

def part2
  cs = [1, 0, -1, 0]
  ss = [0, 1, 0, -1]
  rotate = 3.times.map do |a|
    4.times.map do |r|
      m = [
        [1, 0, 0],
        [0, cs[r], -ss[r]],
        [0, ss[r], cs[r]],
      ]
      Matrix.build(4, 4) do |i, j|
        if i < 3 && j < 3
          m[(i+3-a)%3][(j+3-a)%3]
        elsif i == 3 && j == 3
          1
        else
          0
        end
      end
    end
  end
  os = [
    [0, 0],
    [1, 0],
    [2, 0],
    [3, 0],
    [0, 1],
    [0, 3],
  ].flat_map {|yaw, pitch|
    4.times.map {|roll|
      rotate[2][yaw] * rotate[1][pitch] * rotate[0][roll]
    }
  }
  #puts os
  coords = []
  $stdin.each_line do |l|
    case l
    when /--- scanner \d+ ---/
      coords << Set.new
    when /(-?\d+),(-?\d+),(-?\d+)/
      coords.last << Vector[*[$1, $2, $3].map(&:to_i), 1]
    end
  end
  n = coords.size
  ts = [Matrix[[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]], Matrix[[1, 0, 0, 4], [0, -1, 0, -1098], [0, 0, -1, -3554], [0, 0, 0, 1]], Matrix[[0, -1, 0, -48], [0, 0, -1, 2519], [1, 0, 0, -2343], [0, 0, 0, 1]], Matrix[[0, -1, 0, -36], [0, 0, 1, 2485], [-1, 0, 0, -3558], [0, 0, 0, 1]], Matrix[[0, 1, 0, 1224], [0, 0, 1, 1325], [1, 0, 0, -3545], [0, 0, 0, 1]], Matrix[[0, 1, 0, 78], [0, 0, -1, -2429], [-1, 0, 0, -2231], [0, 0, 0, 1]], Matrix[[0, 0, 1, 2395], [0, -1, 0, 133], [1, 0, 0, -3474], [0, 0, 0, 1]], Matrix[[-1, 0, 0, 123], [0, 1, 0, 4828], [0, 0, -1, -4691], [0, 0, 0, 1]], Matrix[[-1, 0, 0, 56], [0, 0, 1, 67], [0, 1, 0, -5949], [0, 0, 0, 1]], Matrix[[0, 0, -1, 1345], [0, -1, 0, 6], [-1, 0, 0, 107], [0, 0, 0, 1]], Matrix[[0, 0, 1, -27], [0, 1, 0, 1299], [-1, 0, 0, -3572], [0, 0, 0, 1]], Matrix[[-1, 0, 0, 1315], [0, 0, -1, -31], [0, -1, 0, -4751], [0, 0, 0, 1]], Matrix[[0, 0, 1, -1085], [1, 0, 0, -58], [0, 1, 0, -5842], [0, 0, 0, 1]], Matrix[[0, 1, 0, -31], [-1, 0, 0, 3683], [0, 0, 1, -4764], [0, 0, 0, 1]], Matrix[[0, 0, -1, -3], [0, 1, 0, -15], [1, 0, 0, -2245], [0, 0, 0, 1]], Matrix[[1, 0, 0, -1221], [0, 0, 1, -26], [0, -1, 0, -4764], [0, 0, 0, 1]], Matrix[[1, 0, 0, 1310], [0, 0, -1, 133], [0, 1, 0, -6008], [0, 0, 0, 1]], Matrix[[0, 0, -1, 1340], [-1, 0, 0, -37], [0, 1, 0, -7123], [0, 0, 0, 1]], Matrix[[0, 0, 1, 1202], [-1, 0, 0, 8], [0, -1, 0, -3438], [0, 0, 0, 1]], Matrix[[0, 1, 0, 1324], [1, 0, 0, 2484], [0, 0, -1, -2397], [0, 0, 0, 1]], Matrix[[-1, 0, 0, 1307], [0, -1, 0, -1210], [0, 0, 1, -5991], [0, 0, 0, 1]], Matrix[[0, -1, 0, -34], [-1, 0, 0, 85], [0, 0, -1, -1193], [0, 0, 0, 1]], Matrix[[0, -1, 0, 95], [1, 0, 0, 3646], [0, 0, 1, -3433], [0, 0, 0, 1]], Matrix[[0, 0, -1, 89], [1, 0, 0, 11], [0, -1, 0, -3550], [0, 0, 0, 1]], Matrix[[-1, 0, 0, 71], [0, 0, -1, 69], [0, -1, 0, -4818], [0, 0, 0, 1]], Matrix[[0, 0, -1, 117], [1, 0, 0, -2299], [0, -1, 0, -3519], [0, 0, 0, 1]], Matrix[[1, 0, 0, 147], [0, 1, 0, -3613], [0, 0, 1, -2366], [0, 0, 0, 1]]]
=begin
  ts = Array.new(n)
  ts[0] = rotate[0][0]
  ps = <<EOS.each_line.map {|s| s =~ /Found (\d+) -> (\d+)/; [$1, $2].map(&:to_i) }
Found 0 -> 9
Found 0 -> 21
Found 21 -> 14
Found 14 -> 23
Found 23 -> 1
Found 23 -> 10
Found 23 -> 18
Found 23 -> 24
Found 1 -> 25
Found 10 -> 3
Found 10 -> 4
Found 18 -> 6
Found 18 -> 11
Found 24 -> 8
Found 24 -> 15
Found 25 -> 5
Found 3 -> 2
Found 3 -> 22
Found 11 -> 16
Found 8 -> 12
Found 5 -> 26
Found 2 -> 19
Found 22 -> 13
Found 16 -> 17
Found 16 -> 20
Found 13 -> 7
EOS
  ps.each do |(a, b)|
    puts "Examining #{a} -> #{b}"
    t_ab = os.lazy.flat_map {|o| coords[a].lazy.flat_map {|v| coords[b].lazy.map {|w| o + (Matrix.build(4, 3) { 0 }.hstack(v - o * w)) } } }.find {|t|
      #coords[b].count {|z| coords[a].member?(t * z) } >= 12
      ct, cf, r = 0, 0, false
      for z in coords[b]
        if coords[a].member?(t * z)
          ct += 1
        else
          cf += 1
        end
        if ct >= 12
          r = true
          break
        elsif coords[b].size - cf < 12
          break
        end
      end
      r
    }
    if t_ab
      puts "Found #{a} -> #{b}"
      ts[b] = ts[a] * t_ab
    end
  end
=end
  p n.times.map {|a| ts[a] * Vector[0, 0, 0, 1] }.combination(2).map {|v, w| (v - w).map(&:abs).sum }.max
end

part2
