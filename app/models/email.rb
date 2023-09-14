class Email < ActiveRecord::Base
  attr_accessible :body, :subject
  belongs_to :step
end
