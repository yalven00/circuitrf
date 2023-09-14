class Billingsubscription < ActiveRecord::Base
  attr_accessible :amount, :billing_period, :card_number, :card_code, :token
  belongs_to :plan
end
