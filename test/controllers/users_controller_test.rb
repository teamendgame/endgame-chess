require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = FactoryGirl.create(:user)
  end

  test "should get show" do
    sign_in @user
    get :show, id: @user.id
    assert_response :success
  end
end
