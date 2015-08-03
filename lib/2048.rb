TOP_LEFT_CHAR = "\u250C"
TOP_CENTER_CHAR = "\u252C"
TOP_RIGHT_CHAR = "\u2510"
MIDDLE_LEFT_CHAR = "\u251C"
MIDDLE_RIGHT_CHAR = "\u2524"
BOTTOM_LEFT_CHAR = "\u2514"
BOTTOM_CENTER_CHAR = "\u2534"
BOTTOM_RIGHT_CHAR = "\u2518"
HORIZONTAL_BAR_CHAR = "\u2500"
VERTICAL_BAR_CHAR = "\u2502"
CROSS_SECTION_CHAR = "\u253C"

def play
  board = generate_board
  score = 0

  until game_over?(board)
    print_board(board, score)
    board, score = shift_tiles(board, score, ask_for_move)
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

def print_board(board, score)
  system("clear") or system("cls")
  print_score_board(board.length, score)
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

def print_score_board(length, score)
  score_string = "Score: #{score}"
  puts "#{TOP_LEFT_CHAR}#{HORIZONTAL_BAR_CHAR * (score_string.length + 2)}#{TOP_RIGHT_CHAR}".rjust((length * 7) + 1)
  puts "#{VERTICAL_BAR_CHAR} #{score_string} #{VERTICAL_BAR_CHAR}".rjust((length * 7) + 1)
end

def print_gui_top_bar(length)
  puts "#{TOP_LEFT_CHAR}#{([(HORIZONTAL_BAR_CHAR * 6)] * length).join(TOP_CENTER_CHAR)}#{TOP_RIGHT_CHAR}"
end

def print_gui_bottom_bar(length)
  puts "#{BOTTOM_LEFT_CHAR}#{([(HORIZONTAL_BAR_CHAR * 6)] * length).join(BOTTOM_CENTER_CHAR)}#{BOTTOM_RIGHT_CHAR}"
end

def print_empty_gui_row(length)
  puts "#{VERTICAL_BAR_CHAR}#{([' ' * 6] * length).join(VERTICAL_BAR_CHAR)}#{VERTICAL_BAR_CHAR}"
end

def print_gui_tile_row(row)
  inner_string = row.map { |tile| "#{tile}".center(6) }.join(VERTICAL_BAR_CHAR)
  puts "#{VERTICAL_BAR_CHAR}#{inner_string}#{VERTICAL_BAR_CHAR}"
end

def print_horizontal_bar(length)
  puts "#{MIDDLE_LEFT_CHAR}#{(["#{HORIZONTAL_BAR_CHAR}" * 6] * length).join(CROSS_SECTION_CHAR)}#{MIDDLE_RIGHT_CHAR}"
end

def say(message)
  puts "=> #{message}"
end

def shift_tiles(board, score, direction)
  rotated_board = []

  case direction
  when 'up'
    rotated_board        = rotate_board_to_the_right(board)
    rotated_board, score = combine_tiles(rotated_board, score)
    rotated_board        = rotate_board_to_the_right(rotated_board, 3)
  when 'right'
    rotated_board, score = combine_tiles(board, score)
  when 'down'
    rotated_board        = rotate_board_to_the_right(board, 3)
    rotated_board, score = combine_tiles(rotated_board, score)
    rotated_board        = rotate_board_to_the_right(rotated_board)
  when 'left'
    rotated_board        = rotate_board_to_the_right(board, 2)
    rotated_board, score = combine_tiles(rotated_board, score)
    rotated_board        = rotate_board_to_the_right(rotated_board, 2)
  end

  rotated_board = add_random_tile(rotated_board) unless board == rotated_board
  [rotated_board, score]
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

def combine_tiles(board, score)
  internal_board = Marshal.load(Marshal.dump(board))

  internal_board.each do |row|
    index = 0

    row.compact!

    while index < internal_board.length
      if row[index] && row[index] == row[index + 1]
        score += row[index]
        row[index] *= 2
        row.delete_at(index + 1)
      end

      index += 1
    end

    until row.length == internal_board.length
      row.unshift nil
    end
  end

  [internal_board, score]
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
