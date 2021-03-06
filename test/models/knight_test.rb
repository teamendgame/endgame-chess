require 'test_helper'
class KnightTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
  end

  test "move to valid position" do
    @knight = Knight.last
    expected = true
    actual = @knight.valid_move?(5, 5)
    assert_equal expected, actual
  end

  test "move to blocked cell" do
    @knight = Knight.last
    expected = false
    actual = @knight.valid_move?(6, 4)
    assert_equal expected, actual
  end

  test "outside valid position" do
    @knight = Knight.last
    expected = false
    actual = @knight.valid_move?(7, 3)
    assert_equal expected, actual
  end
end
