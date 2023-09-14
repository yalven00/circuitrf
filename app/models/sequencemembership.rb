class Sequencemembership < ActiveRecord::Base
   
  belongs_to :contact
  belongs_to :sequence	
  attr_accessible :contact_id, :sequence_id, :status, :step_id
end
