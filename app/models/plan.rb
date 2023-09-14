class Plan < ActiveRecord::Base
  attr_accessible :contacts, :monthly_emails, :name, :price, :sequences
  belongs_to :account
  has_one :billingsubscription
end
