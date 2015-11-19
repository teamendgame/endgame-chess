require 'test_helper'
class KingTest < ActiveSupport::TestCase
  def create_game
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
  end

  test "outside destination" do
    create_game
    # the last King that gets created on the board is a black king at position (7,4)
    @king1 = King.last
    expected = false
    actual = @king1.valid_move?(7, 2)
    assert_equal expected, actual
  end

  test "inside destination but blockated" do
    create_game
    # the last King that gets created on the board is a black king at position (7,4)
    @king1 = King.last
    expected = false
    actual = @king1.valid_move?(7, 3)
    assert_equal expected, actual
  end

  test "inside destination, not blockated" do
    create_game
    # creating an extra white king in a location where it can move
    # rubocop:disable Metrics/LineLength
    @king1 = Piece.create(type: "King", row_position: 5, col_position: 4, user_id: @user1.id, game_id: @g.id)
    expected = true
    actual = @king1.valid_move?(6, 4)
    assert_equal expected, actual
  end

  test "inside destination, not blockated2" do
    create_game
    # creating an extra black king in a location where it can move
    @king1 = Piece.create(type: "King", row_position: 5, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @king1.valid_move?(4, 5)
    assert_equal expected, actual
  end
end
