class Smtpsetting < ActiveRecord::Base
	belongs_to :account
   attr_accessible :email, :username, :password, :server

   def password
  	key = "helloworld123"
  	encrypted_data = read_attribute(:password)
  	AESCrypt.decrypt(encrypted_data, key)
  end

  def password=(pwd)
  	key = "helloworld123"
  	encrypted_data = AESCrypt.encrypt(pwd, key)
  	write_attribute(:password, encrypted_data)
  end
end
