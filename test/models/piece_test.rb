require 'test_helper'

class PieceTest < ActiveSupport::TestCase
  def setup
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @piece1 = Piece.create(type: "Pawn", row_position: 4, col_position: 2, user_id: @user1.id, captured: false)
    @piece2 = Piece.create(type: "Pawn", row_position: 5, col_position: 1, user_id: @user2.id, captured: false)
    @piece3 = Piece.create(type: "Pawn", row_position: 5, col_position: 2, user_id: @user1.id, captured: false)
  end

  test "capture logic" do
    @piece1.move_to!(5, 1)
    expected = true
    actual = @piece2.reload.captured
    assert_equal expected, actual
    assert @piece1.row_position == 5 && @piece1.col_position == 1
  end

  test "blank cell" do
    @piece1.move_to!(6, 2)
    assert @piece1.row_position == 6 && @piece1.col_position == 2
  end

  test "same user" do
    @piece1.move_to!(5, 2)
    assert @piece1.row_position == 4 && @piece1.col_position == 2
  end
end
