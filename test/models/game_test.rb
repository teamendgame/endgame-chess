require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @g = Game.create(name: "New Game", white_player_id: 1, black_player_id: 1)
  end

  test "board populated with pieces" do
    expected = 32
    actual = @g.pieces.count
    assert_equal expected, actual
  end

  test "king in correct position" do
    expected = [4, 7]
    actual = [@g.pieces.last.col_position, @g.pieces.last.row_position]
    assert_equal expected, actual

    expected_type = "King"
    actual_type = @g.pieces.last.type
    assert_equal expected_type, actual_type
  end

  test "pawn in correct position" do
    expected = [7, 1]
    actual = [@g.pieces.first.col_position, @g.pieces.first.row_position]
    assert_equal expected, actual

    expected_type = "Pawn"
    actual_type = @g.pieces.first.type
    assert_equal expected_type, actual_type
  end
end
