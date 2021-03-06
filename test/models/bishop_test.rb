require 'test_helper'
class BishopTest < ActiveSupport::TestCase
  # rubocop:disable Metrics/LineLength
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 0)
    @g.populate_board!
    @black_bishop = @g.pieces.where(row_position: 7, col_position: 5, type: "Bishop").first
  end

  test "valid move for bishop" do
    # Move pawn so Bishop is not obstructed
    @pawn = @g.pieces.where(row_position: 6, col_position: 4, type: "Pawn").first
    @pawn.move_to!(4, 4)
    expected = true
    actual = @black_bishop.valid_move?(5, 3)
    assert_equal expected, actual
  end

  test "invalid moves for bishop" do
    # Bishop lands on own pawn
    expected = false
    actual = @black_bishop.valid_move?(6, 4)
    assert_equal expected, actual

    # Bishop moves horizontally
    expected = false
    actual = @black_bishop.valid_move?(5, 5)
    assert_equal expected, actual

    # Bishop is obstructed
    expected = false
    actual = @black_bishop.valid_move?(5, 3)
    assert_equal expected, actual
  end
end
