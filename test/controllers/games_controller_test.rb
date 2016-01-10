require 'test_helper'
# rubocop:disable Metrics/LineLength
class GamesControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @g = Game.create(name: "Test", white_player_id: @user.id, turn_number: 0)
    @g2 = Game.create(name: "Test 2", white_player_id: @user.id, black_player_id: @user2.id, turn_number: 0)
    @g2.populate_board!
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
    get :show, id: @g2.id
    assert_response :success
  end

  test "should get search page" do
    sign_in @user2
    get :search, email: @user.email
    assert_response :success
  end

  test "user shouldn't be able to access game show page" do
    sign_in @user3
    get :show, id: @g2.id

    assert_redirected_to games_path

    assert_equal "Sorry, you're not a player in that game", flash[:alert]
  end

  test "user shouldn't be able to access show page if second player has not joined" do
    sign_in @user3
    get :show, id: @g.id

    assert_redirected_to games_path

    assert_equal "Sorry, you have to join the game first", flash[:alert]
  end
end
