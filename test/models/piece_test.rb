require 'test_helper'
# rubocop:disable Metrics/ClassLength
class PieceTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
  end

  test "king is not moving into check" do
    @game = Game.create(name: "A Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 3)
    #@white_bishop = @game.pieces.create(type: "Bishop", col_position: 4, row_position: 5, user_id: @user1.id)
    @white_king = @game.pieces.create(type: "King", row_position: 1, col_position: 0, user_id: @user1.id)
    @black_pawn = @game.pieces.create(type: "Pawn", row_position: 3, col_position: 0, user_id: @user2.id)

    expected = false
    actual = @white_king.moving_into_check?(1, 1)
    assert_equal expected, actual
  end

  test "king is moving into check" do
    @game = Game.create(name: "A Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 3)
    #@white_bishop = @game.pieces.create(type: "Bishop", col_position: 4, row_position: 5, user_id: @user1.id)
    @white_king = @game.pieces.create(type: "King", row_position: 1, col_position: 0, user_id: @user1.id)
    @black_pawn = @game.pieces.create(type: "Pawn", row_position: 3, col_position: 0, user_id: @user2.id)

    expected = true
    actual = @white_king.moving_into_check?(2, 1)
    assert_equal expected, actual
  end

  test "king is moving into check2" do
    @game = Game.create(name: "A Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 3)
    @white_bishop = @game.pieces.create(type: "Bishop", row_position: 4, col_position: 5, user_id: @user1.id)
    @white_king = @game.pieces.create(type: "King", row_position: 4, col_position: 6, user_id: @user1.id)
    @black_queen = @game.pieces.create(type: "Queen", row_position: 2, col_position: 7, user_id: @user2.id)

    expected = true
    actual = @white_king.moving_into_check?(4, 7)
    assert_equal expected, actual
  end

  test "bishop is moving into check" do
    @game = Game.create(name: "A Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 3)
    @white_bishop = @game.pieces.create(type: "Bishop", row_position: 3, col_position: 6, user_id: @user1.id)
    @white_king = @game.pieces.create(type: "King", row_position: 4, col_position: 5, user_id: @user1.id)
    @black_queen = @game.pieces.create(type: "Queen", row_position: 2, col_position: 7, user_id: @user2.id)

    expected = true
    actual = @white_bishop.moving_into_check?(4, 7)
    assert_equal expected, actual
  end

  test "queen is not moving into check" do
    @game = Game.create(name: "A Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 4)
    @white_bishop = @game.pieces.create(type: "Bishop", row_position: 4, col_position: 5, user_id: @user1.id)
    @black_king = @game.pieces.create(type: "King", row_position: 2, col_position: 3, user_id: @user2.id)
    @black_queen = @game.pieces.create(type: "Queen", row_position: 3, col_position: 2, user_id: @user2.id)

    expected = false
    actual = @black_queen.moving_into_check?(3, 4)
    assert_equal expected, actual
  end

  test "queen is moving into check" do
    @game = Game.create(name: "A Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 4)
    @white_bishop = @game.pieces.create(type: "Bishop", row_position: 4, col_position: 5, user_id: @user1.id)
    @black_king = @game.pieces.create(type: "King", row_position: 2, col_position: 3, user_id: @user2.id)
    @black_queen = @game.pieces.create(type: "Queen", row_position: 3, col_position: 4, user_id: @user2.id)

    expected = true
    actual = @black_queen.moving_into_check?(3, 7)
    assert_equal expected, actual
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

  # rubocop:disable Metrics/LineLength
  test "valid pawn capture with move_to!" do
    black_pawn = Pawn.last
    white_pawn = Pawn.create(row_position: 5, col_position: 1, game_id: @g.id, user_id: @user1.id)
    black_pawn.move_to!(5, 1)
    expected = true
    actual = white_pawn.reload.captured
    assert_equal expected, actual
    assert black_pawn.row_position == 5 && black_pawn.col_position == 1
  end

  test "valid move to blank square" do
    black_pawn = Pawn.last
    black_pawn.move_to!(5, 0)
    assert black_pawn.row_position == 5 && black_pawn.col_position == 0
  end

  test "invalid move to square with your own piece" do
    black_pawn = Pawn.last
    Pawn.find_by(row_position: 6, col_position: 1).update(row_position: 5, col_position: 0)
    black_pawn.move_to!(5, 0)
    assert black_pawn.row_position == 6 && black_pawn.col_position == 0
  end

  test "invalid move for pawn" do
    # Pawn is at (6, 0)
    pawn = Pawn.last
    pawn.move_to!(5, 7)
    pawn.reload
    assert pawn.row_position == 6 && pawn.col_position == 0
  end

  test "valid move for king" do
    # King is at (7, 4)
    king = King.last
    @g.pieces.find_by(row_position: 6, col_position: 4).destroy
    king.move_to!(6, 4)
    king.reload
    assert king.row_position == 6 && king.col_position == 4
  end

  test "invalid move for king" do
    # King is at (7, 4)
    king = King.last
    @g.pieces.find_by(row_position: 6, col_position: 4).destroy
    king.move_to!(5, 4)
    king.reload
    assert king.row_position == 7 && king.col_position == 4
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

  test "not own piece?" do
    @bishop_black = Piece.where(row_position: 7, col_position: 5).first
    expected = false
    actual = @bishop_black.own_piece?(1, 5)
    assert_equal expected, actual
  end
end
