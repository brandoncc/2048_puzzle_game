def play
  board = generate_board

  until game_over?(board)
    print_board(board)
    board = shift_tiles(board, ask_for_move)
  end

  puts 'Game over, thanks for playing!'
end

def ask_for_move
  input_mappings = { 'u' => 'up', 'd' => 'down', 'l' => 'left', 'r' => 'right' }
  say 'What direction would you like to shift the tiles? (U/D/L/R)'

  input = gets.chomp.downcase

  until input_mappings.keys.include?(input)
    puts
    puts 'Sorry, that is not a valid response.'
    say 'What direction would you like to shift the tiles? (U/D/L/R)'
    input = gets.chomp
  end

  input_mappings[input]
end

def print_board(board)
  system("clear") or system("cls")
  print_gui_top_bar(board.length)

  board.each_with_index do |row, index|
    print_empty_gui_row(board.length)
    print_gui_tile_row(row)
    print_empty_gui_row(board.length)

    if index < board.length - 1
      print_horizontal_bar(board.length)
    end
  end

  print_gui_bottom_bar(board.length)
end

def print_gui_top_bar(length)
  bar_char = "\u2500"
  puts "\u250C" + ([(bar_char * 6)] * length).join("\u252C") + "\u2510"
end

def print_gui_bottom_bar(length)
  bar_char = "\u2500"
  puts "\u2514" + ([(bar_char * 6)] * length).join("\u2534") + "\u2518"
end

def print_empty_gui_row(length)
  puts "\u2502" + ([' ' * 6] * length).join("\u2502") + "\u2502"
end

def print_gui_tile_row(row)
  inner_string = row.map { |tile| "#{tile}".center(6) }.join("\u2502")
  puts "\u2502#{inner_string}\u2502"
end

def print_horizontal_bar(length)
  puts "\u251C" + (["\u2500" * 6] * length).join("\u253C") + "\u2524"
end

def say(message)
  puts "=> #{message}"
end

def shift_tiles(board, direction)
  rotated_board = []

  case direction
  when 'up'
    rotated_board = rotate_board_to_the_right(board)
    rotated_board = combine_tiles(rotated_board)
    rotated_board = rotate_board_to_the_right(rotated_board, 3)
  when 'right'
    rotated_board = combine_tiles(board)
  when 'down'
    rotated_board = rotate_board_to_the_right(board, 3)
    rotated_board = combine_tiles(rotated_board)
    rotated_board = rotate_board_to_the_right(rotated_board)
  when 'left'
    rotated_board = rotate_board_to_the_right(board, 2)
    rotated_board = combine_tiles(rotated_board)
    rotated_board = rotate_board_to_the_right(rotated_board, 2)
  end

  rotated_board = add_random_tile(rotated_board) unless board == rotated_board
  rotated_board
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
