 module GlobalConstants
  # This is a constants file that doesn't require a server restart and you can use these constants like GlobalConstants::STORAGE
  # if Rails.env.production?
  # 	PROTOCOL = 'https'
  # else
  # 	PROTOCOL = 'http'

  # end
# ACCOUNT_SID = 'AC34c808c17d7dfe7825c42e0960b99b0b'
# AUTH_TOKEN = 'c370859be7d064d385d6751bf5070daa'

	ACCOUNT_SID = 'AC23140f7d130cbb604b06bd037cb58bb1'
	AUTH_TOKEN  = 'bbc7b51cf298fe2bf215218ee2c646bb'
	NEWSLETTER_LIST_KEY = "c3ae84898a"

	STRIPE_KEY = "sk_test_mS1aK7I2FZ8TnLIODiZiHStE"
	MANDRILL_KEY ="5mdS2TEsBMC7kDh6vy3bQQ"
	SM_ACTIVE = "active"
	SM_PAUSED = "paused"
	SM_COMPLETED = "completed"
	NE_QUEUED = "queued"
	NE_CANCELED = "canceled"
	NE_SENT = "sent"
	NE_FAIL = "failed"

	DAYS = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
	OPTIONS = ['Hours', 'Days', 'Weeks', 'Months']
end

