require 'minitest/autorun'
require 'minitest/stub_any_instance'
require_relative '../lib/2048'

class Test2048 < Minitest::Test
  def setup
    @board_with_one_combination_available =
      [[nil, 2, 8], [nil, 4, 4], [8, 4, 16]]

    # Move up and combination should be: [[nil, 2, 8], [nil, 8, 16], [8, nil, nil]]
    @board_with_two_combinations_available =
      [[nil, 2, 4], [nil, 4, 4], [8, 4, 16]]
  end

  def test_random_tile_is_added
    stub :random_2_or_4, 2 do
      Array.stub_any_instance :sample, 6 do
        board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        board = shift_tiles(board, 'up')
        assert_equal [[nil, nil, nil], [nil, nil, nil], [2, nil, nil]], board
      end
    end
  end

  def test_random_tile_is_either_2_or_4
    random_tiles = []
    1000.times { random_tiles << random_2_or_4 }
    assert_equal random_tiles.uniq.sort, [2, 4]
  end

  def test_game_is_over_when_board_is_full_and_no_combinations_are_possible
    board = [[2, 4, 2], [4, 2, 4], [2, 4, 2]]
    assert_equal true, game_over?(board)
  end

  def test_game_is_not_over_if_there_are_any_nil_positions
    board = [[nil, 4, 2], [4, 2, 4], [2, 4, 2]]
    assert_equal false, game_over?(board)
  end

  def test_game_is_not_over_if_there_are_any_available_combinations
    board = [[4, 4, 2], [4, 2, 4], [2, 4, 2]]
    assert_equal false, game_over?(board)
  end

  def test_board_can_be_rotated
    before = [[nil, 2, 8], [nil, 4, 4], [8, 4, 16]]
    after  = [[8, nil, nil], [4, 4, 2], [16, 4, 8]]
    assert_equal after, rotate_board_to_the_right(before, 1)
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
    before = [[2, 2, 8, 8], [2, 2, 2, 2], [2, 2, 2, 2], [4, 4, 4, 4]]
    after = [[nil, nil, 4, 16], [nil, nil, 4, 4], [nil, nil, 4, 4], [nil, nil, 8, 8]]
    assert_equal after, combine_tiles(before)
  end

  def test_tiles_only_combine_once_per_turn
    before = [[nil, 2, 2, 4], [2, 2, 2, 2], [2, 2, 2, 2], [4, 4, 4, 4]]
    after = [[nil, nil, 4, 4], [nil, nil, 4, 4], [nil, nil, 4, 4], [nil, nil, 8, 8]]
    assert_equal after, combine_tiles(before)
  end
end
