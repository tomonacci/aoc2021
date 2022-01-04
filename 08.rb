def part1
  cs = $stdin.each_line.flat_map {|l| ds = l.scan(/\w+/); ds[10..-1] }.map(&:size).tally
  p cs[2] + cs[4] + cs[3] + cs[7]
end

def part2
  valid_outputs = %w[
    abcefg
    cf
    acdeg
    acdfg
    bcdf
    abdfg
    abdefg
    acf
    abcdefg
    abcdfg
  ].map {|o| o.chars.map {|c| c.ord - ?a.ord }.join }
  p $stdin.each_line.map {|l|
    ds = l.scan(/\w+/).map {|d| d.chars.map {|c| c.ord - ?a.ord } }
    ys = (0...7).to_a.permutation.find {|xs|
      ds.all? {|d| valid_outputs.member?(d.map {|i| xs[i] }.sort.join) }
    }
    ds[10..-1].map {|d| valid_outputs.find_index(d.map {|i| ys[i] }.sort.join) }.reduce(0) {|a, b| a * 10 + b }
  }.sum
end

part2
