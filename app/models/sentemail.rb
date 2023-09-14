class Sentemail < ActiveRecord::Base
  attr_accessible :date, :email_id, :history_id, :sequence_id, :step_id
  belongs_to :history
end
