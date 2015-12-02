require 'test_helper'
# rubocop:disable Metrics/LineLength
class PiecesControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
    @g = Game.create(name: "Test", white_player_id: @user.id, turn_number: 0)
    @piece = Piece.create(type: "Pawn", col_position: 1, row_position: 1, user_id: @user.id, game_id: @g.id)
  end

  # test "should get show" do
  #   sign_in @user
  #   get :show, id: @piece.id
  #   assert_response :success
  # end

  # test "should update piece location" do
  #   sign_in @user
  #   put :update, id: @piece.id, col_position: 2, row_position: 2
  #   @piece.reload

  #   expected_row_position = 2
  #   expected_col_position = 2
  #   assert_equal expected_col_position, @piece.col_position
  #   assert_equal expected_row_position, @piece.row_position

  #   assert_redirected_to game_path(@piece.game_id)
  # end
end
