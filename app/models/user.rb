class User < ActiveRecord::Base
	TEMP_EMAIL = 'change@me.com'
  TEMP_EMAIL_REGEX = /change@me.com/
  has_one :account
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :name,:company
  # attr_accessible :title, :body

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    user = identity.user
    if user.nil?

      # Get the existing user from email if the OAuth provider gives us an email
      user = User.where(:email => auth.info.email).first if auth.info.email

      # Create the user if it is a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: auth.info.email.blank? ? TEMP_EMAIL : auth.info.email,
          password: Devise.friendly_token[0,20]
        )

        # user.skip_confirmation!
        user.save!
        account = user.build_account
        account.save!
      end

      # Associate the identity with the user if not already
      if identity.user != user
        identity.user = user
        identity.save!
      end
    end
    user
  end
end
