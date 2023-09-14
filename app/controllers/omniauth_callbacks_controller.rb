class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def twitter
		# puts "====="*222
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:success, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.twitter_uid"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:success, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:success, :success, :kind => "Linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    puts "===="*2222
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:success, :success, :kind => "Linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
