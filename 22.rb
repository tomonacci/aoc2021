def a
  cubes = Array.new(101) { Array.new(101) { Array.new(101, false) } }
  $stdin.each_line do |l|
    l =~ /(on|off) x=([+-]?\d+)\.\.([+-]?\d+),y=([+-]?\d+)\.\.([+-]?\d+),z=([+-]?\d+)\.\.([+-]?\d+)/
    on, *coords = $1 == 'on', $2, $3, $4, $5, $6, $7
    x1, x2, y1, y2, z1, z2 = coords.map {|s| s.to_i.clamp(-51..51) + 50 }
    for x in x1..x2
      for y in y1..y2
        for z in z1..z2
          cubes[x][y][z] = on if 0 <= x && x <= 100 && 0 <= y && y <= 100 && 0 <= z && z <= 100
        end
      end
    end
  end
  p cubes.flatten.count(&:itself)
end

def b
  insts = $stdin.each_line.map do |l|
    l =~ /(on|off) x=([+-]?\d+)\.\.([+-]?\d+),y=([+-]?\d+)\.\.([+-]?\d+),z=([+-]?\d+)\.\.([+-]?\d+)/
    on, *coords = $1 == 'on', $2, $3, $4, $5, $6, $7
    [on, coords.map {|s| s.to_i }]
  end
  xs, ys, zs = [], [], []
  insts.each do |_, (x1, x2, y1, y2, z1, z2)|
    xs << x1 << x2 + 1
    ys << y1 << y2 + 1
    zs << z1 << z2 + 1
  end
  xs.sort!
  ys.sort!
  zs.sort!
  xis = xs.each_with_index.with_object({}) {|(x, i), o| o[x] = i }
  yis = ys.each_with_index.with_object({}) {|(y, i), o| o[y] = i }
  zis = zs.each_with_index.with_object({}) {|(z, i), o| o[z] = i }
  cuboids = xs.map { ys.map { zs.map { false } } }
  insts.each do |on, (x1, x2, y1, y2, z1, z2)|
    for xi in xis[x1]...xis[x2+1]
      for yi in yis[y1]...yis[y2+1]
        for zi in zis[z1]...zis[z2+1]
          cuboids[xi][yi][zi] = on
        end
      end
    end
  end
  c = 0
  xs.size.times {|i|
    ys.size.times {|j|
      zs.size.times {|k|
        c += (xs[i+1] - xs[i]) * (ys[j+1] - ys[j]) * (zs[k+1] - zs[k]) if cuboids[i][j][k]
      }
    }
  }
  p c
end

#a # 607657
b # 1187742789778677
