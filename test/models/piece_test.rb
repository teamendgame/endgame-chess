require 'test_helper'

class PieceTest < ActiveSupport::TestCase
	def create_game
		@user1 = FactoryGirl.create(:user)
	  @user2 = FactoryGirl.create(:user)
		@g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
	end

	test "is_obstructed?" do
		create_game

		# test moving to a destination where there is a piece
		# get the black pawn, set it to captured, test rook can move to white pawn in same column
		@pawn_black = Piece.where(row_position: 6, col_position: 0).first
		@pawn_black.update(captured: true)
		@rook_black = Piece.where(row_position: 7, col_position: 0).first

		expected = false
	  actual = @rook_black.is_obstructed?(1, 0)
	  assert_equal expected, actual

	  # test is_obstructed? for a knight
	  @knight_white = Piece.where(row_position: 0, col_position: 1).first

	  expected = "Invalid input! Knight can't be obstructed."
	  actual = @knight_white.is_obstructed?(2, 2)
	  assert_equal expected, actual

	  # test for obstruction where move is diagonal
	  @bishop_white = Piece.where(row_position: 0, col_position: 2).first

	  expected = true
	  actual = @bishop_white.is_obstructed?(2, 4)
	  assert_equal expected, actual
	end

end
