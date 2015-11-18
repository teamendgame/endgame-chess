require 'test_helper'

class FacebookOmniauthTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      uid: '12345',
      provider: 'facebook',
      info: { name: 'Joe Bloggs', email: 'joe@bloggs.com' },
      credentials: {
        token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
        expires_at: 1_321_747_205, # when the access token expires (it always will)
        expires: true # this will always be true
      })
  end

  def teardown
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.test_mode = false
  end

  test "user can login with Facebook Omniauth" do
    get new_user_session_path
    assert_response :success

    get_via_redirect("/users/auth/facebook")
    assert_equal root_path, path
    assert_equal "Successfully authenticated from Facebook account.", flash[:notice]
  end
end
