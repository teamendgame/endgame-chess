require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "board populated with pieces" do 
    g = Game.create(:name => "New Game", :white_player_id => 1, :black_player_id => 1)
    expected = 32
    actual = g.pieces.count
    assert_equal expected, actual
  end
end
