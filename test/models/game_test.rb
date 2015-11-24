require 'test_helper'
# rubocop:disable Metrics/LineLength
class GameTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 1)
    @g.populate_board!
  end

  test "count board is populated with 32 pieces" do
    expected = 32
    actual = @g.pieces.count
    assert_equal expected, actual
  end

  test "count black player has 16 pieces" do
    expected = 16
    actual = @g.pieces.where(user_id: @user2.id).count
    assert_equal expected, actual
  end

  test "count white player has 16 pieces" do
    expected = 16
    actual = @g.pieces.where(user_id: @user1.id).count
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

  test "should be black player's turn" do
    expected = @user2.id
    actual = @g.whos_turn?

    assert_equal expected, actual
  end
end
