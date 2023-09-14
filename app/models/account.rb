class Account < ActiveRecord::Base
	belongs_to :user
	has_many :contacts
	has_many :sequences
	has_one :plan
	has_one :imapsetting
	has_one :smtpsetting
  	attr_accessible :user_id
end
