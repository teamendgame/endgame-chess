require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
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
end
