class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :ensure_valid_email

  def ensure_valid_email
    # Ensure we don't go into an infinite loop
    return if action_name == 'add_email'

    # If the email address was the temporarily assigned one, 
    # redirect the user to the 'add_email' page
    if current_user && (!current_user.email || current_user.email == User::TEMP_EMAIL)
      redirect_to add_user_email_path(current_user)
    end
  end
end
