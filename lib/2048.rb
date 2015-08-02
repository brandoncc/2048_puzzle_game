def shift_tiles(board, direction)
  add_random_tile(board)
end

def add_random_tile(board)
  new_tile = random_2_or_4
  board_side_length = board.length
  nil_tile_indexes = board.flatten.map.with_index { |element, index| index unless element }.compact
  random_index = nil_tile_indexes[rand(nil_tile_indexes.count)]
  board[board_side_length / random_index][board_side_length % random_index] = new_tile
end

def random_2_or_4
  rand(10) == 1 ? 4 : 2
end

def game_over?(board)
  return false if board.flatten.include?(nil)
  return false if board_has_combination_available?(board)

  true
end

def rotate_board_to_the_right(board, times = 1)
  reversed_board = board.reverse
  rotated_board  = []

  board.length.times do |row|
    rotated_board[row] = []

    board.length.times do |column|
      rotated_board[row] << reversed_board[column][row]
    end
  end

  rotated_board
end

private

def board_has_combination_available?(board)
  board.each do |row|
    return true if row_has_combination_available?(row)
  end

  rotate_board_to_the_right(board).each do |row|
    return true if row_has_combination_available?(row)
  end

  false
end

def row_has_combination_available?(row)
  (row.length - 1).times do |index|
    return true if row[index] == row[index + 1]
  end

  false
end
