task :NextEmail =>:environment do
    # require 'mandrill'
    # m = Mandrill::API.new(GlobalConstants::MANDRILL_KEY)

    puts date = DateTime.now
    @users = User.all

    @users && @users.each do |user|
        user.account.contacts && user.account.contacts.each do |contact|
            puts "contact"
            # seq_mem = contact.sequencememberships.first
            # @nextemails = Nextemail.where("date <= ? AND status='queued' AND sequencemembership_id=?",date,seq_mem.id)
            @nextemails = contact.queued.nextemails.where("date <= ? AND status='queued'",date)
            @nextemails && @nextemails.each do |nextemail|
                puts "email"
                email = Email.find(nextemail.email_id)
                begin
                    ContactMailer.cron_emails(contact,email,user.account).deliver
                    history = contact.history || contact.build_history
                    history.save!
                    sentemail = history.sentemails.build
                    sentemail.email_id = nextemail.email_id
                    sentemail.sequence_id = nextemail.sequence_id
                    sentemail.step_id = nextemail.step_id
                    sentemail.date  = DateTime.now  
                    sentemail.save!
                    nextemail.status = GlobalConstants::NE_SENT  #"sent"
                    # nextemail.response = sending[0]["_id"]
                    nextemail.save!
                rescue 
                    puts "failed to send"
                    nextemail.status = GlobalConstants::NE_FAIL #"failed"
                    # nextemail.response = sending[0]["_id"]
                    nextemail.save!
                end
                sequence = Sequence.find(nextemail.sequence_id)
                step_number = Step.find(nextemail.step_id).step_number
                step = sequence.steps.where(:sequence_id=>nextemail.sequence_id, :step_number=>step_number.to_i+1).first
                if step.present?
                    status = Sequencemembership.where(:sequence_id=>nextemail.sequence_id).first.status
                    if status == GlobalConstants::SM_ACTIVE #"active"
                      nextemail = contact.queued.nextemails.build
                      nextemail.sequence_id = step.sequence_id
                      nextemail.step_id = step.id
                      nextemail.status = GlobalConstants::NE_QUEUED  #"queued"
                      nextemail.email_id = step.email.id
                      delay = step.delay
                      schedule = step.schedule
                      if schedule == 0
                        nextemail.date = DateTime.now + delay.to_i.hour
                      elsif schedule == 1
                        nextemail.date = DateTime.now + delay.to_i.day
                      elsif schedule == 2
                        nextemail.date = DateTime.now + delay.to_i.week
                      elsif schedule == 3
                        nextemail.date = DateTime.now + delay.to_i.month
                      else
                      end
                      # nextemail.date = Date.today + step.delay.to_i.day
                      nextemail.save!                                  
                    end
                else
                    sequence_membership = contact.sequencememberships.where(:sequence_id => nextemail.sequence_id).first
                    sequence_membership.status = GlobalConstants::SM_COMPLETED
                    sequence_membership.save!
                end


            end # end nextemail loop
        end # end of contact loop
    end   # end of user loop 
    @nextemails = Nextemail.where("date <= ? AND status='sent'",date)   
    @nextemails && @nextemails.each do |nextemail|
        nextemail.destroy
    end
end  # end of environment

