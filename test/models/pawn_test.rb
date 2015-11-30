require 'test_helper'
class PawnTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
  end

  test "valid move to white pawn" do
    @pawn = Pawn.first
    expected = true
    actual = @pawn.valid_move?(7, 2)
    assert_equal expected, actual
  end

  test "valid move to black pawn" do
    #Position of last created pawn is (6, 0)
    @pawn = Pawn.last
    expected = true
    actual = @pawn.valid_move?(5, 0)
    assert_equal expected, actual
  end

  test "invalid move to pawn" do
    #Position of last created pawn is (6, 0)
    @pawn = Pawn.last
    expected = false
    actual = @pawn.valid_move?(3, 0)
    assert_equal expected, actual
  end

   test "can eat opponents peace" do
     @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 2, user_id: @user1.id, game_id: @g.id)
     @pawn2 = Pawn.create(type: "Pawn", row_position: 5, col_position: 3, user_id: @user2.id, game_id: @g.id)
     expected = true
     actual = @pawn1.valid_move?(5, 3)
     assert_equal expected, actual
   end

  test "can't eat opponents peace" do
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

  test "horizontal move to pawn" do
    @pawn = Pawn.create(type: "Pawn", row_position: 5, col_position: 0, user_id: @user2.id, game_id: @g.id)
    expected = false
    actual = @pawn.valid_move?(5, 1)
    assert_equal expected, actual
  end

  test "backward move to black pawn" do
    @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 0, user_id: @user2.id, game_id: @g.id)
    expected = false
    actual = @pawn1.backward_move?(5, 0)
    assert_equal expected, actual
  end

  test " white pawn backward move" do
    @pawn1 = Pawn.create(type: "Pawn", row_position: 4, col_position: 0, user_id: @user1.id, game_id: @g.id)
    expected = false
    actual = @pawn1.backward_move?(3, 0)
    assert_equal expected, actual
  end

end