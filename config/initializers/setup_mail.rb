ActionMailer::Base.smtp_settings = {
  :address              => "",
  :port                 => 587,
  	# :port => 465,
  # :domain               => "asciicasts.com",
  :user_name            => "",
  :password             => "",
  :authentication       => "plain",
  :enable_starttls_auto => true
}