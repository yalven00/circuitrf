class Imapsetting < ActiveRecord::Base
  attr_accessible :account_id, :email, :password, :server, :username
  belongs_to :account
  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :server, presence: true
  validates :username, presence: true

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
