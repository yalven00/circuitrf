class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
  attr_accessible :uid, :provider


  def self.find_for_oauth(auth)
  	# puts "==="*222
  	# puts auth.inspect
  	# puts "==="*222
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    if identity.nil?
      identity = Identity.create(uid: auth.uid, provider: auth.provider)
    end
    identity
  end


end
