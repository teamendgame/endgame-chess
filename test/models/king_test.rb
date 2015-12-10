require 'test_helper'
class KingTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 0)
    @g.populate_board!
  end

  test "kingside castle when both pieces have not moved yet" do
    # King pos (7, 4)
    # Rook pos (7, 7)
    @king = King.last
    @rook = Rook.last
    Piece.find_by(row_position: 7, col_position: 6).destroy
    Piece.find_by(row_position: 7, col_position: 5).destroy
    @king.can_castle?(@rook.row_position, @rook.col_position)
    assert_equal 6, @king.reload.col_position
    assert_equal 5, @rook.reload.col_position
  end

  test "queenside castle when both pieces have not moved yet" do
    @king = King.last
    @rook = Rook.find_by(row_position: 7, col_position: 0)
    Piece.find_by(row_position: 7, col_position: 3).destroy
    Piece.find_by(row_position: 7, col_position: 2).destroy
    Piece.find_by(row_position: 7, col_position: 1).destroy
    @king.can_castle?(@rook.row_position, @rook.col_position)
    assert_equal 2, @king.reload.col_position
    assert_equal 3, @rook.reload.col_position
  end

  test "castle when is obstructed" do
    @king = King.last
    @rook = Rook.last
    can_castle = @king.can_castle?(@rook.row_position, @rook.col_position)
    assert_equal false, can_castle
  end

  test "castle when king has moved" do
    @king = King.last
    @rook = Rook.last
    Piece.find_by(row_position: 7, col_position: 6).destroy
    Piece.find_by(row_position: 7, col_position: 5).destroy
    @king.move_to!(7, 5)
    can_castle = @king.can_castle?(@rook.row_position, @rook.col_position)
    assert_equal false, can_castle
  end

  test "castle when rook has moved" do
    @king = King.last
    @rook = Rook.last
    Piece.find_by(row_position: 7, col_position: 6).destroy
    Piece.find_by(row_position: 7, col_position: 5).destroy
    @rook.move_to!(7, 5)
    @rook.move_to!(7, 7)
    can_castle = @king.can_castle?(@rook.row_position, @rook.col_position)
    assert_equal false, can_castle
  end

  test "outside destination" do
    # the last King that gets created on the board is a black king at position (7,4)
    @king1 = King.last
    expected = false
    actual = @king1.valid_move?(7, 2)
    assert_equal expected, actual
  end

  test "inside destination but blocked" do
    # the last King that gets created on the board is a black king at position (7,4)
    @king1 = King.last
    expected = false
    actual = @king1.valid_move?(7, 3)
    assert_equal expected, actual
  end

  test "inside destination, not blocked" do
    # creating an extra white king in a location where it can move
    # rubocop:disable Metrics/LineLength
    @king1 = Piece.create(type: "King", row_position: 5, col_position: 4, user_id: @user1.id, game_id: @g.id)
    expected = true
    actual = @king1.valid_move?(6, 4)
    assert_equal expected, actual
  end

  test "inside destination, not blocked 2" do
    # creating an extra black king in a location where it can move
    @king1 = Piece.create(type: "King", row_position: 5, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @king1.valid_move?(4, 5)
    assert_equal expected, actual
  end
end
