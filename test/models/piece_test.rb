require 'test_helper'

class PieceTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
  end

  test "unobstructed castling" do
    @king = King.last
    Piece.find_by(row_position: 7, col_position: 6).destroy
    Piece.find_by(row_position: 7, col_position: 5).destroy
    @king.move_to!(7, 7)
    expected = 6
    actual = @king.reload.col_position
    assert_equal expected, actual
  end

  test "obstructed castling" do
    @king = King.last
    @king.move_to!(7, 7)
    assert_equal 4, @king.reload.col_position
  end

  test "capture pawn with other pawn" do
    black_pawn = Pawn.last
    white_pawn = Pawn.first
    white_pawn.update(row_position: 5, col_position: 1)
    black_pawn.move_to!(5, 1)
    expected = true
    actual = white_pawn.reload.captured
    assert_equal expected, actual
    assert black_pawn.row_position == 5 && black_pawn.col_position == 1
  end

  test "move to blank cell" do
    black_pawn = Pawn.last
    black_pawn.move_to!(5, 0)
    assert black_pawn.row_position == 5 && black_pawn.col_position == 0
  end

  test "same user" do
    black_pawn = Pawn.last
    Pawn.find_by(row_position: 6, col_position: 1).update(row_position: 5, col_position: 0)
    black_pawn.move_to!(5, 0)
    assert black_pawn.row_position == 6 && black_pawn.col_position == 0
  end

  test "obstructed?" do
    # test moving to a destination where there is a piece but no obstruction
    # get the black pawn, set it to captured, test rook can move to white pawn in same column
    @pawn_black = Piece.where(row_position: 6, col_position: 0).first
    @pawn_black.update(captured: true)
    @rook_black = Piece.where(row_position: 7, col_position: 0).first

    expected = false
    actual = @rook_black.obstructed?(1, 0)
    assert_equal expected, actual

    # test rook_black for a horizontal move where there is an obstruction
    expected = true
    actual = @rook_black.obstructed?(7, 2)
    assert_equal expected, actual

    # test is_obstructed? for a knight
    @knight_white = Piece.where(row_position: 0, col_position: 1).first

    expected = "Invalid input! Knight can't be obstructed."
    actual = @knight_white.obstructed?(2, 2)
    assert_equal expected, actual

    # test for obstruction where move is diagonal
    @bishop_white = Piece.where(row_position: 0, col_position: 2).first

    expected = true
    actual = @bishop_white.obstructed?(2, 4)
    assert_equal expected, actual
  end

  test "horizontal move" do
    @rook_black = Piece.where(row_position: 7, col_position: 0).first
    expected = true
    actual = @rook_black.horizontal_move?(7, 3)
    assert_equal expected, actual

    expected = false
    actual = @rook_black.horizontal_move?(5, 3)
    assert_equal expected, actual
  end

  test "vertical move" do
    @rook_black = Piece.where(row_position: 7, col_position: 0).first
    expected = true
    actual = @rook_black.vertical_move?(5, 0)
    assert_equal expected, actual

    expected = false
    actual = @rook_black.vertical_move?(7, 3)
    assert_equal expected, actual
  end

  test "diagonal move" do
    @bishop_black = Piece.where(row_position: 7, col_position: 5).first
    expected = true
    actual = @bishop_black.diagonal_move?(5, 3)
    assert_equal expected, actual

    # testing a horizontal move
    expected = false
    actual = @bishop_black.diagonal_move?(7, 3)
    assert_equal expected, actual

    # testing a vertical move
    expected = false
    actual = @bishop_black.diagonal_move?(5, 5)
    assert_equal expected, actual
  end

  test "own piece?" do
    @bishop_black = Piece.where(row_position: 7, col_position: 5).first
    expected = true
    actual = @bishop_black.own_piece?(7, 4)
    assert_equal expected, actual
  end
end
