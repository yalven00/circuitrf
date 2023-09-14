class History < ActiveRecord::Base
  attr_accessible :contact_id
  belongs_to :contact
  has_many :sentemails
end
