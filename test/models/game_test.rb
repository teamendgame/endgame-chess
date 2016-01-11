require 'test_helper'
# rubocop:disable Metrics/LineLength
class GameTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 1)
    @g.populate_board!
  end

  test "should not be in stalemate" do
    @game = Game.create(name: "Check Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 2)
    @white_bishop = @game.pieces.create(type: "Bishop", col_position: 4, row_position: 5, user_id: @user1.id)
    @white_king = @game.pieces.create(type: "King", col_position: 4, row_position: 7, user_id: @user1.id)
    @black_king = @game.pieces.create(type: "King", col_position: 3, row_position: 0, user_id: @user2.id)

    @white_bishop.move_to!(3, 6)
    @game.update(turn_number: 3)

    assert_equal false, @game.determine_stalemate
  end

  test "move_to should result in stalemate" do
    @game = Game.create(name: "Stalemate Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 3)
    @white_king = @game.pieces.create(type: "King", col_position: 5, row_position: 1, user_id: @user1.id)
    @black_king = @game.pieces.create(type: "King", col_position: 7, row_position: 0, user_id: @user2.id)
    @white_queen = @game.pieces.create(type: "Queen", col_position: 6, row_position: 2, user_id: @user1.id)

    expected = true
    actual = @game.determine_stalemate
    assert_equal expected, actual
  end

  test "should be in stalemate" do
    @game = Game.create(name: "Stalemate Game", white_player_id: @user1.id, black_player_id: @user2.id, turn_number: 3)
    @white_king = @game.pieces.create(type: "King", col_position: 5, row_position: 1, user_id: @user1.id)
    @black_king = @game.pieces.create(type: "King", col_position: 7, row_position: 0, user_id: @user2.id)
    @white_queen = @game.pieces.create(type: "Queen", col_position: 6, row_position: 2, user_id: @user1.id)

    expected = true
    actual = @game.determine_stalemate
    assert_equal expected, actual
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
