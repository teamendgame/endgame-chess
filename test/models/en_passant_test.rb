require 'test_helper'
# rubocop:disable Metrics/LineLength
class EnPassantTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 0)
    @g.populate_board!
  end

  test "En Passant with adjacent pieces on both sides" do
    @black_pawn = Pawn.create(row_position: 3, col_position: 5, game_id: @g.id, user_id: @user2.id)
    @white_pawn = Pawn.find_by(row_position: 1, col_position: 6, game_id: @g.id)
    @white_pawn_2 = Pawn.find_by(row_position: 1, col_position: 4, game_id: @g.id)
    @white_pawn.move_to!(3, 6)
    @white_pawn_2.move_to!(3, 4)
    @black_pawn.move_to!(2, 4)
    assert_equal 2, @black_pawn.reload.row_position
  end

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

  test "Valid En Passant" do
    @g1 = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 0)
    @black_pawn = Pawn.create(row_position: 3, col_position: 7, game_id: @g1.id, user_id: @user2.id)
    @white_pawn = Pawn.create(row_position: 1, col_position: 6, game_id: @g1.id, user_id: @user1.id)
    @w_king = King.create(row_position: 0, col_position: 0, game_id: @g1.id, user_id: @user1.id)
    @white_pawn.move_to!(3, 6)
    @black_pawn.move_to!(2, 6)
    assert_equal 2, @black_pawn.reload.row_position
    assert_equal true, @white_pawn.reload.captured
  end
end
