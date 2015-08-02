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
