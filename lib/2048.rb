def shift_tiles(board, direction)
  case direction
  when 'up'
    rotated_board = rotate_board_to_the_right(board)
    board = combine_tiles(rotated_board)
    board = rotate_board_to_the_right(rotated_board, 3)
  when 'right'
    board = combine_tiles(board)
  when 'down'
    rotated_board = rotate_board_to_the_right(board, 3)
    board = combine_tiles(rotated_board)
    board = rotate_board_to_the_right(rotated_board)
  when 'left'
    rotated_board = rotate_board_to_the_right(board, 2)
    board = combine_tiles(rotated_board)
    board = rotate_board_to_the_right(rotated_board, 2)
  end

  add_random_tile(board)
end

def add_random_tile(board)
  new_tile = random_2_or_4
  board_side_length = board.length
  nil_tile_indexes = board.flatten.map.with_index { |element, index| index unless element }.compact
  random_index = nil_tile_indexes.sample
  board[random_index / board_side_length][random_index % board_side_length] = new_tile
  board
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
  rotated_board  = nil

  times.times do
    reversed_board = board.reverse
    rotated_board  = []

    board.length.times do |row|
      rotated_board[row] = []

      board.length.times do |column|
        rotated_board[row] << reversed_board[column][row]
      end
    end

    board = rotated_board
  end

  board
end

def combine_tiles(board)
  board.each do |row|
    index = 0

    row.compact!

    while index < board.length
      if row[index] && row[index] == row[index + 1]
        row[index] *= 2
        row.delete_at(index + 1)
      end

      index += 1
    end

    until row.length == board.length
      row.unshift nil
    end
  end

  board
end

def generate_board(size = 4)
  board = []

  size.times do
    board << []

    size.times do
      board.last << nil
    end
  end

  2.times do
    board = add_random_tile(board)
  end

  board
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
