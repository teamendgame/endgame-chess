class Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # rubocop:disable Metrics/AbcSize
    def facebook
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_path
      end
    end
  end
end