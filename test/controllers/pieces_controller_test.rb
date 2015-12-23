require 'test_helper'
# rubocop:disable Metrics/LineLength, Metrics/AbcSize
class PiecesControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @g = Game.create(name: "Test", white_player_id: @user.id, black_player_id: @user2.id, turn_number: 0)
    @pawn = Piece.create(type: "Pawn", col_position: 1, row_position: 1, user_id: @user.id, game_id: @g.id)
    @black_pawn = Piece.create(type: "Pawn", col_position: 1, row_position: 6, user_id: @user2.id, game_id: @g.id)
    @white_rook_queenside = Piece.create(type: "Rook", col_position: 0, row_position: 0, user_id: @user.id, game_id: @g.id)
    @white_rook_kingside = Piece.create(type: "Rook", col_position: 7, row_position: 0, user_id: @user.id, game_id: @g.id)
  end

  test "Player should not be able to update on incorrect turn" do
    sign_in @user
    sign_in @user2
    put :update, id: @black_pawn.id, piece: { type: @black_pawn.type, col_position: 2, row_position: 2 }
    assert_equal 6, @black_pawn.row_position
    assert_redirected_to game_path(@g)
  end

  test "Flash message should appear if player chooses invalid move" do
    sign_in @user
    put :update, id: @pawn.id, piece: { type: @pawn.type, col_position: 1, row_position: 4 }

    assert_redirected_to game_path(@g.id)
    assert_not flash[:alert].nil?
  end

  test "should update piece location" do
    sign_in @user
    put :update, id: @pawn.id, game_id: @g.id, piece: { type: @pawn.type, col_position: 1, row_position: 2 }
    @pawn.reload
    @g.reload

    # Test for new position of pawn
    expected_row_position = 2
    expected_col_position = 1
    assert_equal expected_col_position, @pawn.col_position
    assert_equal expected_row_position, @pawn.row_position

    # Test that turn number updated
    assert_equal 1, @g.turn_number

    assert render_template: { text: 'updated!' }
  end

  test "should allow white player to castle queenside" do
    sign_in @user
    @white_king = Piece.create(type: "King", col_position: 4, row_position: 0, user_id: @user.id, game_id: @g.id)
    get :castle_queenside, game_id: @g.id

    assert flash[:alert].nil?

    assert_redirected_to game_path(@g.id)
  end

  test "should allow white player to castle kingside" do
    sign_in @user
    @white_king = Piece.create(type: "King", col_position: 4, row_position: 0, user_id: @user.id, game_id: @g.id)
    get :castle_kingside, game_id: @g.id

    assert flash[:alert].nil?

    assert_redirected_to game_path(@g.id)
  end

  test "should have flash error when white player tries to castle queenside" do
    sign_in @user
    @white_king_moved = Piece.create(type: "King", col_position: 4, row_position: 0, user_id: @user.id, game_id: @g.id, moved: true)

    get :castle_queenside, game_id: @g.id

    assert_not flash[:alert].nil?
    assert_redirected_to game_path(@g.id)
  end

  test "should have flash error when white player tries to castle queenside with obstruction" do
    sign_in @user
    @white_king = Piece.create(type: "King", col_position: 4, row_position: 0, user_id: @user.id, game_id: @g.id)
    @white_bishop = Piece.create(type: "Bishop", col_position: 2, row_position: 0, user_id: @user.id, game_id: @g.id)

    get :castle_queenside, game_id: @g.id

    assert_not flash[:alert].nil?
    assert_redirected_to game_path(@g.id)
  end

  test "should have flash error when white player tries to castle kingside" do
    sign_in @user
    @white_king_moved = Piece.create(type: "King", col_position: 4, row_position: 0, user_id: @user.id, game_id: @g.id, moved: true)

    get :castle_kingside, game_id: @g.id

    assert_not flash[:alert].nil?
    assert_redirected_to game_path(@g.id)
  end
end
