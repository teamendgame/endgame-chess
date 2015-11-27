require 'test_helper'
class QueenTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
  end

  test "queen steps on own king" do
    # the last Queen that gets created on the board is a black king at position (7,3)
    @queen1 = Queen.last
    expected = false
    actual = @queen1.valid_move?(7, 2)
    assert_equal expected, actual
  end


  test "queen obstructed" do
    # the last Queen that gets created on the board is a black king at position (7,3)
    @queen1 = Queen.last
    expected = false
    actual = @queen1.valid_move?(5, 1)
    assert_equal expected, actual
  end
  
  test "valid horizontal move" do
    # creating an extra black quuen in a location where it can move
    #setup
    @queen1 = Piece.create(type: "Queen", row_position: 5, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @queen1.valid_move?(5, 1)
    assert_equal expected, actual
  end

  test "valid vertical move" do
    # creating an extra black quuen in a location where it can move
    #setup
    @queen1 = Piece.create(type: "Queen", row_position: 5, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @queen1.valid_move?(2, 4)
    assert_equal expected, actual
  end

  test "valid diagonal move" do
    # creating an extra black queen in a location where it can move
    @queen1 = Piece.create(type: "Queen", row_position: 5, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @queen1.valid_move?(3, 2)
    assert_equal expected, actual
  end 

  test "valid diagonal move2" do
    # creating an extra black queen in a location where it can move
    setup
    @queen1 = Piece.create(type: "Queen", row_position: 4, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = true
    actual = @queen1.valid_move?(2, 6)
    assert_equal expected, actual
  end 

  test "wrong direction move" do
    # creating an extra black quuen in a location where it can move
    #setup
    @queen1 = Piece.create(type: "Queen", row_position: 5, col_position: 4, user_id: @user2.id, game_id: @g.id)
    expected = false
    actual = @queen1.valid_move?(2, 0)
    assert_equal expected, actual
  end 
end
