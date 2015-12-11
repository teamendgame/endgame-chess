require 'test_helper'
# rubocop:disable Metrics/LineLength
class PawnTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 0)
    @g.populate_board!
  end

  # test "En Passant with adjacent pieces on both sides" do
  #   @black_pawn = Pawn.create(row_position: 3, col_position: 5, game_id: @g.id, user_id: @user2.id)
  #   @white_pawn = Pawn.find_by(row_position: 1, col_position: 6, game_id: @g.id)
  #   @white_pawn_2 = Pawn.find_by(row_position: 1, col_position: 4, game_id: @g.id)
  #   @white_pawn.move_to!(3, 6)
  #   @white_pawn_2.move_to!(3, 4)
  #   @black_pawn.move_to!(2, 4)
  #   assert_equal 2, @black_pawn.reload.row_position
  # end

  test "En Passant when Adjacent Piece is not a Pawn" do
    @black_pawn = Pawn.create(row_position: 3, col_position: 0, game_id: @g.id, user_id: @user2.id)
    @white_rook = Rook.create(row_position: 3, col_position: 1, game_id: @g.id, user_id: @user1.id)
    @black_pawn.move_to!(2, 1)
    assert_equal 3, @black_pawn.reload.row_position
  end

  test "Obstructed En Passant should capture" do
    @black_pawn = Pawn.create(row_position: 3, col_position: 7, game_id: @g.id, user_id: @user2.id)
    @white_pawn = Pawn.create(row_position: 3, col_position: 6, game_id: @g.id, user_id: @user1.id)
    @white_pawn_2 = Pawn.create(row_position: 2, col_position: 6, game_id: @g.id, user_id: @user1.id)
    @black_pawn.move_to!(2, 6)
    assert_equal 2, @black_pawn.reload.row_position
    assert_equal true, @white_pawn_2.reload.captured
  end

  test "En Passant attempt when last updated Pawn only moved 1 square in previous turn" do
    @black_pawn = Pawn.create(row_position: 3, col_position: 7, game_id: @g.id, user_id: @user2.id)
    @white_pawn = Pawn.find_by(col_position: 6, game_id: @g.id)
    @white_pawn.move_to!(2, 6)
    @white_pawn.move_to!(3, 6)
    @black_pawn.move_to!(2, 6)
    assert_equal 3, @black_pawn.reload.row_position
    assert_equal false, @white_pawn.reload.captured
  end

  # test "Valid En Passant" do
  #   @black_pawn = Pawn.create(row_position: 3, col_position: 7, game_id: @g.id, user_id: @user2.id)
  #   @white_pawn = Pawn.find_by(row_position: 1, col_position: 6, game_id: @g.id)
  #   @white_pawn.move_to!(3, 6)
  #   @g.update(turn_number: 1)
  #   @black_pawn.move_to!(2, 6)
  #   assert_equal 2, @black_pawn.reload.row_position
  #   assert_equal true, @white_pawn.reload.captured
  # end

  test "En Passant creating check" do
    @black_pawn = Pawn.create(row_position: 3, col_position: 7, game_id: @g.id, user_id: @user2.id)
    @white_pawn = Pawn.find_by(row_position: 1, col_position: 6, game_id: @g.id)
    @black_king = Piece.create(type: "King", row_position: 4, col_position: 7, game_id: @g.id, user_id: @user2.id)
    @white_queen = Piece.create(type: "Queen", row_position: 2, col_position: 7, game_id: @g.id, user_id: @user1.id)
    @white_pawn.move_to!(3, 6)
    @g.update(turn_number: 1)
    @black_pawn.move_to!(2, 6)
    assert_equal 3, @black_pawn.reload.row_position
    assert_equal false, @white_pawn.reload.captured
  end

  test "pawn valid move" do
    @pawn1 = Pawn.first
    expected = true
    actual = @pawn1.valid_move?(2, 7)
    assert_equal expected, actual
    @pawn2 = Pawn.last
    expected = true
    actual = @pawn2.valid_move?(4, 0)
    assert_equal expected, actual
  end

  test "pawn invalid move" do
    @pawn = Pawn.first
    expected = false
    actual = @pawn.valid_move?(4, 7)
    assert_equal expected, actual
  end

  test "valid diagonal killing move" do
    @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 2, user_id: @user1.id, game_id: @g.id)
    @pawn2 = Pawn.create(type: "Pawn", row_position: 5, col_position: 3, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @pawn1.valid_move?(5, 3)
    assert_equal expected, actual
  end

  test "invalid diagonal killing move" do
    @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 5, user_id: @user1.id, game_id: @g.id)
    @pawn2 = Pawn.create(type: "Pawn", row_position: 3, col_position: 6, user_id: @user2.id, game_id: @g.id)
    expected = false
    actual = @pawn1.valid_move?(3, 6)
    assert_equal expected, actual
  end

  test "invalid diagonal move" do
    @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 5, user_id: @user1.id, game_id: @g.id)
    expected = false
    actual = @pawn1.valid_move?(5, 4)
    assert_equal expected, actual
  end

  test "horizontal move" do
    @pawn = Pawn.create(type: "Pawn", row_position: 5, col_position: 0, user_id: @user2.id, game_id: @g.id)
    expected = false
    actual = @pawn.valid_move?(5, 1)
    assert_equal expected, actual
  end

  test "black pawn backward move" do
    @pawn = Pawn.create(type: "Pawn", row_position: 4, col_position: 0, user_id: @user2.id, game_id: @g.id)
    expected = false
    actual = @pawn.valid_move?(5, 0)
    assert_equal expected, actual
  end

  test " white pawn backward move" do
    @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 0, user_id: @user1.id, game_id: @g.id)
    expected = false
    actual = @pawn1.valid_move?(3, 0)
    assert_equal expected, actual
  end
end
