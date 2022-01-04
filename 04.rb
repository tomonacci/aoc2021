def a
  called_numbers = gets.split(?,).map(&:to_i)
  boards = []
  while gets
    boards << 5.times.map { gets.split(' ').map(&:to_i) }
  end
  for called_number in called_numbers
    winning_board = boards.find do |board|
      5.times {|i| 5.times {|j| board[i][j] = -1 if called_number == board[i][j] } }
      5.times.any? {|i| 5.times.all? {|j| board[i][j] < 0 } } ||
      5.times.any? {|j| 5.times.all? {|i| board[i][j] < 0 } }
    end
    if winning_board
      p winning_board.flatten.select {|x| x >= 0 }.sum * called_number
      break
    end
  end
end

def b
  called_numbers = gets.split(?,).map(&:to_i)
  boards = []
  while gets
    boards << 5.times.map { gets.split(' ').map(&:to_i) }
  end
  skip = boards.map { false }
  scores = []
  for called_number in called_numbers
    boards.each_with_index do |board, i|
      next if skip[i]
      5.times {|i| 5.times {|j| board[i][j] = -1 if called_number == board[i][j] } }
      next unless 5.times.any? {|i| 5.times.all? {|j| board[i][j] < 0 } } || 5.times.any? {|j| 5.times.all? {|i| board[i][j] < 0 } }
      skip[i] = true
      scores << board.flatten.select {|x| x >= 0 }.sum * called_number
    end
  end
  p scores.last
end

#a # 28082
b # 8224
