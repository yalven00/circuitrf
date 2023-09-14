class StepsController < ApplicationController
	
	def add_step
		if params[:complete_option] == "true"
			@sequence = Sequence.find(params[:id])
			@step = @sequence.steps.build
			# puts params[:option]
			# puts @sequence.steps.count
			if params[:option] == 'true' && @sequence.steps.count == 0
				@step.delay = 0
			else
				@step.delay = params[:delay]
				@step.schedule = params[:type]
			end
			# @step.delay = params[:delay]
			@step.step_number = @sequence.steps.count + 1
			@step.save!
			email = @step.build_email
			email.subject = params[:subject]
			email.body = params[:body]
			email.save!
			# respond_to do |format|
			# 	format.json do 
			# 	 return render :json => @step
			# 	end
			# end
			############################
			# puts "==="*222
			puts params[:complete_option]
			
			contacts = current_user.account.contacts
			contacts.each do |contact|
				contact.sequencememberships.where(:sequence_id => @sequence.id,:status => "completed") && contact.sequencememberships.where(:sequence_id => @sequence.id,:status => "completed").each do |sequencemembership|
					  sequencemembership.status = GlobalConstants::SM_ACTIVE #active
					  sequencemembership.save!
					  nextemail = contact.queued.nextemails.build
                      nextemail.sequence_id = @sequence.id
                      nextemail.step_id = @step.id
                      nextemail.status = GlobalConstants::NE_QUEUED  #"queued"
                      nextemail.email_id = @step.email.id
                      delay = @step.delay
                      schedule = @step.schedule
                      last_reply_datetime = contact.last_reply_date
                      if schedule == 0
                        last_reply_datetime = last_reply_datetime.to_i + delay.to_i.hour
                      elsif schedule == 1
                        last_reply_datetime = last_reply_datetime.to_i + delay.to_i.day
                      elsif schedule == 2
                        last_reply_datetime = last_reply_datetime.to_i + delay.to_i.week
                      elsif schedule == 3
                        last_reply_datetime = last_reply_datetime.to_i + delay.to_i.month
                      else
                      end

                      if last_reply_datetime.to_i > DateTime.now.to_i + 1.hour
                      	nextemail.date = last_reply_datetime
                      else
                      	nextemail.date = DateTime.now + 1.hour
                      end
                      # nextemail.date = Date.today + step.delay.to_i.day
                      nextemail.save!

                  	  respond_to do |format|
						format.json do 
						 return render :json => @step
						end
					  end 
				end
			end
		else
			# puts "==="*222
			puts params[:complete_option]
			@sequence = Sequence.find(params[:id])
		
			# @step = Step.find(params[:step_id])
			# puts @step.inspect
			# puts @step.step_number
			if params[:step_id].present?
				@step = Step.find(params[:step_id])
				# puts @step.inspect
				if params[:option] == 'true' && @step.step_number == 1
					@step.delay = 0
					@step.schedule = nil
				else
					@step.delay = params[:delay]
					@step.schedule = params[:type]
				end
				@step.save!
				email = Email.find(@step.email.id)
				email.subject = params[:subject]
				email.body = params[:body]
				email.save!
				respond_to do |format|
					format.js do 
				  		return render js: "window.location='#{edit_sequence_path(@sequence)}';"
				  	end
				end
			else
				@step = @sequence.steps.build
				# puts params[:option]
				# puts @sequence.steps.count
				if params[:option] == 'true' && @sequence.steps.count == 0
					@step.delay = 0
				else
					@step.delay = params[:delay]
					@step.schedule = params[:type]
				end
				# @step.delay = params[:delay]
				@step.step_number = @sequence.steps.count + 1
				@step.save!
				email = @step.build_email
				email.subject = params[:subject]
				email.body = params[:body]
				email.save!
				respond_to do |format|
					format.json do 
					 return render :json => @step
					end
				end
			end
		end
		
	end

	def get_step
		@step = Step.find(params[:id])
		return render :json => @step
	end

	def count_step
		sequence = Sequence.find(params[:id])
		# puts "=="*90
		# puts sequence.inspect
		# puts sequence.steps.count
		if sequence.steps.count > 0
			return render :text=>true
		else
			return render :text=>false
		end
	end

	def destroy
		step = Step.find(params[:id])
		sequence = Sequence.find(step.sequence_id)
		step_all = sequence.steps
		step_all.each do |step_a|
			if step_a.step_number.to_i > step.step_number.to_i
				step_a.step_number = step_a.step_number.to_i - 1
				step_a.save!
			end
		end
		step.email.destroy if step.email.present?
		step.destroy if step.present?
		redirect_to edit_sequence_path(sequence)
	end
end