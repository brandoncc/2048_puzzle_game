require 'minitest/autorun'
require '2048'

class Test2048 < Minitest::Test
  def test_random_tile_is_added
  end

  def test_random_tile_is_either_2_or_4
  end

  def test_game_is_over_when_board_is_full_and_no_combinations_are_possible
  end

  def test_board_can_be_shifted_up
  end

  def test_board_can_be_shifted_right
  end

  def test_board_can_be_shifted_down
  end

  def test_can_be_shifted_left
  end

  def test_board_shifts_even_if_no_combinations_are_possible
  end

  def test_multiple_combinations_are_possible_in_one_line_in_one_turn
  end

  def test_tiles_only_combine_once_per_turn
  end
end
