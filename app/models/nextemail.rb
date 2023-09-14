class Nextemail < ActiveRecord::Base
  attr_accessible :date, :email_id, :response, :sequence_id, :status, :step_id, :queued_id
  belongs_to :queued
end
