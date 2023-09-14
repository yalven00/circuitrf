class Sequence < ActiveRecord::Base
  attr_accessible :name, :stop_toggle
  has_many :sequencememberships
  has_many :steps
  belongs_to :account

end
