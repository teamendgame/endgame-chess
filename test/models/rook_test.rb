require 'test_helper'
class RookTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
    @g.populate_board!
    @black_bishop = @g.pieces.where(row_position: 7, col_position: 5, type: "Bishop").first
  end

  test "valid move for rook" do
  	@rook_black = Piece.find_by(row_position: 7, col_position: 7)
  	@pawn_black = Piece.find_by(row_position: 6, col_position: 7)
  	@pawn_black.update(captured: true)
  	@row_dest = 6
  	@col_dest = 7

		expected = "bla bla"
		actual = @rook_black.valid_move?(0, 7)
		assert_equal expected, actual
 		
  end

end



