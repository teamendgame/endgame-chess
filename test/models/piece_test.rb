require 'test_helper'

class PieceTest < ActiveSupport::TestCase
	def create_game
		@user1 = FactoryGirl.create(:user)
	  @user2 = FactoryGirl.create(:user)
		@g = Game.create(name: "New Game", white_player_id: @user1.id, black_player_id: @user2.id)
	end

	test "is_obstructed?" do
		# create_game

		# # the last Rook that gets created on the board is a black rook in row 7 col 7.
		# @rook1 = Rook.last
		# @piece = Piece.where(row_position: 6, col_position: 3).first
		# @queen = Queen.last

		# expected = "OBSTRUCTION for ROOK no moves possible"
		# # actual = @piece.is_obstructed?(0, 4)
	 #  actual = @queen.is_obstructed?(1, 5)
	 #  assert_equal expected, actual

	end

end
