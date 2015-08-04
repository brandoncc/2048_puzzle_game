require 'minitest/autorun'
require 'minitest/stub_any_instance'
require_relative '../lib/2048'

class Test2048 < Minitest::Test
  def test_random_tile_is_added
    stub :random_2_or_4, 2 do
      Array.stub_any_instance :sample, 6 do
        board = [[nil, nil, nil], [2, nil, nil], [nil, nil, nil]]
        board = shift_tiles(board, 0, 'up')[0]
        assert_equal [[2, nil, nil], [nil, nil, nil], [2, nil, nil]], board
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
    before = [[nil, 2, nil], [2, nil, 2], [nil, nil, nil]]
    after  = [[2, 2, 2], [nil, nil, nil], [nil, nil, nil]]

    stub :random_2_or_4, nil do
      assert_equal after, shift_tiles(before, 0, 'up')[0]
    end
  end

  def test_board_can_be_shifted_right
    before = [[nil, 2, nil], [2, nil, 2], [nil, nil, nil]]
    after  = [[nil, nil, 2], [nil, nil, 4], [nil, nil, nil]]

    stub :random_2_or_4, nil do
      assert_equal after, shift_tiles(before, 0, 'right')[0]
    end
  end

  def test_board_can_be_shifted_down
    before = [[nil, 2, nil], [2, nil, 2], [nil, nil, nil]]
    after  = [[nil, nil, nil], [nil, nil, nil], [2, 2, 2]]

    stub :random_2_or_4, nil do
      assert_equal after, shift_tiles(before, 0, 'down')[0]
    end
  end

  def test_can_be_shifted_left
    before = [[nil, 2, nil], [2, nil, 2], [nil, nil, nil]]
    after  = [[2, nil, nil], [4, nil, nil], [nil, nil, nil]]

    stub :random_2_or_4, nil do
      assert_equal after, shift_tiles(before, 0, 'left')[0]
    end
  end

  def test_board_shifts_even_if_no_combinations_are_possible
    before = [[2, 4, nil], [2, 8, nil], [nil, nil, nil]]
    after  = [[nil, 2, 4], [nil, 2, 8], [nil, nil, nil]]

    stub :random_2_or_4, nil do
      assert_equal after, shift_tiles(before, 0, 'right')[0]
    end
  end

  def test_board_does_not_change_if_there_are_no_slides_or_combinations_available_that_direction
    before = [[2, 4, nil], [2, 8, nil], [nil, nil, nil]]
    after  = [[2, 4, nil], [2, 8, nil], [nil, nil, nil]]

    assert_equal after, shift_tiles(before, 0, 'left')[0]
  end

  def test_multiple_combinations_are_possible_in_one_line_in_one_turn
    before = [[2, 2, 8, 8], [2, 2, 2, 2], [2, 2, 2, 2], [4, 4, 4, 4]]
    after = [[nil, nil, 4, 16], [nil, nil, 4, 4], [nil, nil, 4, 4], [nil, nil, 8, 8]]
    assert_equal after, combine_tiles(before, 0)[0]
  end

  def test_tiles_only_combine_once_per_turn
    before = [[nil, 2, 2, 4], [2, 2, 2, 2], [2, 2, 2, 2], [4, 4, 4, 4]]
    after = [[nil, nil, 4, 4], [nil, nil, 4, 4], [nil, nil, 4, 4], [nil, nil, 8, 8]]
    assert_equal after, combine_tiles(before, 0)[0]
  end

  def test_random_board_can_be_generated
    possible_boards = [
      [[2, 2], [nil, nil]],
      [[nil, nil], [2, 2]],
      [[2, nil], [2, nil]],
      [[nil, 2], [nil, 2]],
      [[2, nil], [nil, 2]],
      [[nil, 2], [2, nil]]
    ]

    stub :random_2_or_4, 2 do
      assert_includes possible_boards, generate_board(2)
    end
  end

  def test_score_is_tracked
    board = [[2, 2, nil], [nil, nil, nil], [nil, nil, nil]]

    assert_equal 2, shift_tiles(board, 0, 'right')[1]
  end

  def test_combinations_on_far_side_happen_first
    before = [[2, 2, 2], [nil, nil, nil], [nil, nil, nil]]
    after  = [[nil, 2, 4], [nil, nil, nil], [nil, nil, nil]]

    stub :random_2_or_4, nil do
      assert_equal after, shift_tiles(before, 0, 'right')[0]
    end
  end
end
