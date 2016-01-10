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

  test "winning player should be updated to -1 if game is in stalemate" do
    @game = Game.create(name: "Stalemate Game", white_player_id: @user.id, black_player_id: @user2.id, turn_number: 3)
    @white_king = @game.pieces.create(type: "King", col_position: 5, row_position: 1, user_id: @user.id)
    @black_king = @game.pieces.create(type: "King", col_position: 7, row_position: 0, user_id: @user2.id)
    @white_queen = @game.pieces.create(type: "Queen", col_position: 6, row_position: 2, user_id: @user.id)

    sign_in @user
    get :show, id: @game.id

    assert_equal -1, @game.reload.winning_player_id
  end

  test "winning player should be updated" do
    # Set up game
    @game = Game.create(name: "Checkmate Game", white_player_id: @user.id, black_player_id: @user2.id, turn_number: 2)
    @game.pieces.create(type: "Knight", col_position: 5, row_position: 2, user_id: @user2.id)
    @game.pieces.create(type: "Rook", col_position: 7, row_position: 1, user_id: @user2.id)
    @game.pieces.create(type: "King", col_position: 7, row_position: 0, user_id: @user.id)

    sign_in @user
    get :show, id: @game.id

    assert_equal @user2.id, @game.reload.winning_player_id
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
