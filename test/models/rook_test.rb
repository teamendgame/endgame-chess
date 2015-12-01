require 'test_helper'
class RookTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
    @rook_black = Piece.find_by(row_position: 7, col_position: 7)
    @pawn_black = Piece.find_by(row_position: 6, col_position: 7)
    @pawn_black.update(captured: true)
  end

  # valid moves

  test "rook valid move vertical" do
    expected = true
    actual = @rook_black.valid_move?(3, 7)
    assert_equal expected, actual
  end

  test "rook valid move vertical lands on opponent" do
    expected = true
    actual = @rook_black.valid_move?(1, 7)
    assert_equal expected, actual
  end

  test "rook valid move horizontal" do
    @knight_black = Piece.find_by(row_position: 7, col_position: 6)
    @knight_black.update(captured: true)
    expected = true
    actual = @rook_black.valid_move?(7, 6)
    assert_equal expected, actual
  end

  # invalid moves

  test "rook invalid move vertical obstructed opponent piece" do
    expected = false
    actual = @rook_black.valid_move?(0, 7)
    assert_equal expected, actual
  end

  test "rook invalid move vertical obstruction own piece" do
    @pawn_black.update(captured: false)
    expected = false
    actual = @rook_black.valid_move?(5, 7)
    assert_equal expected, actual
  end

  test "rook invalid move vertical own piece in destination" do
    @pawn_black.update(captured: false)
    expected = false
    actual = @rook_black.valid_move?(6, 7)
    assert_equal expected, actual
  end
end
