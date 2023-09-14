task :IMAP =>:environment do
	require 'net/imap'
	
	@users = User.all
    @users && @users.each do |user|

        imapsetting = user.account && user.account.imapsetting
        if imapsetting.present?
        	begin
				imap = Net::IMAP.new(imapsetting.server, 993, true)
				imap.login(imapsetting.email, imapsetting.password)
				imap.select('INBOX')
				# mailIds = imap.search(['NOT','SEEN'])
				date = Time.now.strftime("%d-%b-%Y")
				mailIds = imap.search([ 'UNSEEN', 'SINCE', date.to_s])
				# mailIds = imap.search(['NOT','SEEN'],['SINCE',Date.today])
				# puts "@@"*22
				# puts mailIds.inspect
				mailIds && mailIds.each do |id|
				  msg = imap.fetch(id, 'ENVELOPE')[0].attr['ENVELOPE']
				  # puts "=="*22
				  # puts msg
				  id = msg.sender[0].mailbox
				  host = msg.sender[0].host
				  if id.present? && host.present?
				  	email_id = id +"@"+ host
				    puts email_id
				  end
				  date = msg.date
				  
				  #============= here is the code to update DB fields
					if email_id.present?
						user.account.contacts && user.account.contacts.each do |contact|
							puts "contact"
						  	if email_id == contact.primary_email || email_id == contact.email2 || email_id == contact.email3 || email_id == contact.email4
						  		contact.last_reply_date = date.to_s
						  		contact.save!
						  		next_emails = contact.queued.nextemails.where(:status => GlobalConstants::NE_QUEUED)
						  		next_emails && next_emails.each do |next_email|
						  			sequence = Sequence.find(next_email.sequence_id)
						  			if sequence.stop_toggle.present?
						  				next_email.status = GlobalConstants::NE_CANCELED
						  				next_email.save!
						  				seq_membership = Sequencemembership.where(:contact_id => contact.id,:sequence_id => next_email.sequence_id).first
						  				seq_membership.status = GlobalConstants::SM_PAUSED
						  				seq_membership.save!
						  			end
						  		end
						  	end
						end
					end

				end 
				mailIds.each do |id|
				  msg = imap.fetch(id, 'RFC822')[0].attr['RFC822']
				end
			rescue => ex
				puts ex.message
			end
	    end #end if
	end # end of users loop
end