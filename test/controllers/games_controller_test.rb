require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "Test", white_player_id: @user.id, turn_number: 0)
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "should create game" do
    sign_in @user
    assert_difference('Game.count') do
      post :create, game: { name: "Test", white_player_id: @user.id, turn_number: 0 }
    end

    assert_redirected_to games_path
  end

  test "should get show page" do
    sign_in @user
    get :show, id: @g.id
    assert_response :success
  end

  test "should destroy game" do
    sign_in @user
    assert_difference('Game.count', -1) do
      delete :destroy, id: @g.id
    end

    assert_redirected_to root_path
  end

  test "should get search page" do
    sign_in @user2
    get :search, email: @user.email
    assert_response :success
  end

  test "game is in checkmate" do 
    # Set up game
    @game = Game.create(name: "Checkmate Game", white_player_id: @user.id, black_player_id: @user2.id, turn_number: 2)
    @game.pieces.create(type: "Knight", col_position: 5, row_position: 2, user_id: @user2.id)
    @game.pieces.create(type: "Rook", col_position: 7, row_position: 1, user_id: @user2.id)
    @game.pieces.create(type: "King", col_position: 7, row_position: 0, user_id: @user.id)

    sign_in @user
    get :show, id: @game.id

    assert_equal "White player is in checkmate.  Game Over.", flash[:alert]
    assert_equal @user2.id, @game.reload.winning_player_id
    assert_equal nil, @game.reload.turn_number
  end
end
