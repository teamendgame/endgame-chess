require 'test_helper'

class Users
  class OmniauthCallbacksControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
      OmniAuth.config.test_mode = true
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    def teardown
      OmniAuth.config.mock_auth[:facebook] = nil
      OmniAuth.config.test_mode = false
    end

    test "should login successfully with facebook" do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        uid: '12345',
        provider: 'facebook',
        info: { name: 'Joe Bloggs', email: 'joe@bloggs.com' },
        credentials: {
          token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
          expires_at: 1_321_747_205, # when the access token expires (it always will)
          expires: true # this will always be true
        }
      )
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      assert_difference('User.count') do
        get :facebook
        assert_redirected_to root_path
      end
    end

    test "should redirect to new user sign up if data is invalid" do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        uid: '',
        provider: '',
        info: { name: '', email: '' }
      )
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      assert_no_difference('User.count') do
        get :facebook
        assert_redirected_to new_user_registration_path
      end
    end
  end
end
