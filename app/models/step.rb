class Step < ActiveRecord::Base
  attr_accessible :delay, :sequence_id, :step_number,:subject,:body,:schedule
  belongs_to :sequence
  has_one :email
  attr_accessor :subject,:body
end
