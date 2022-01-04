require 'set'

def part1
  gets =~ /y=(-?\d+)\.\.(-?\d+)/
  y_min, y_max = $1.to_r, $2.to_r
  (-y_min * 2).to_i.downto 1 do |n|
    m = (n - 1) / 2r
    y0_min, y0_max = (y_min / n + m).ceil, (y_max / n + m).floor
    if y0_min <= y0_max
      y0 = y0_min.to_i
      puts y0 * (y0 + 1) / 2
      break
    end
  end
end

def part2
  gets =~ /x=(\d+)\.\.(\d+), y=(-?\d+)\.\.(-?\d+)/
  x_min, x_max = [$1, $2].map(&:to_i)
  y_min, y_max = [$3, $4].map(&:to_r)
  #p [x_min, x_max, y_min, y_max]
  n_min, n_max = 1, (-y_min * 2).to_i
  x0_min, x0_max = (((1 + 8 * x_min) ** 0.5 - 1) / 2).ceil, x_max
  c = 0
  for x0 in x0_min..x0_max
    f = lambda do |x|
      d = (2 * x0 + 1) ** 2 - 8 * x
      break if d < 0
      (2 * x0 + 1 - d ** 0.5) / 2
    end
    n0_min, n0_max = f[x_min].ceil, f[x_max]&.floor
    n0_max = n_max if n0_max.nil? || n0_max >= x0
    #p [x0, n0_min, n0_max]
    y0s = Set.new
    for n in n0_min..n0_max
      m = (n - 1) / 2r
      y0_min, y0_max = [(y_min / n + m).ceil, (y_max / n + m).floor].map(&:to_i)
      for y0 in y0_min..y0_max
        y0s << y0
      end
    end
    c += y0s.size
  end
  puts c
end

part2
