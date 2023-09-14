class ContactsController < ApplicationController
	before_filter :authenticate_user!
	def new
		if current_user.account && current_user.account.smtpsetting.present? && current_user.account.imapsetting.present?
			if current_user.account.sequences.first.present?
				@contact = Contact.new
			else
				flash[:info] = "Please make atleast one sequence to proceed."
				redirect_to new_sequence_path
			end
		else
			flash[:warning] = "Please complete your settings to proceed."
			redirect_to new_imapsetting_path
		end

	end

	def index
		 @contacts = Contact.order("id ASC").page(params[:page]).per_page(5)
		# @contacts = current_user.account && current_user.account.contacts && current_user.account.contacts.order("id ASC").page(params[:page]).per_page(5)
		@contacts = current_user.account && current_user.account.contacts && current_user.account.contacts.order("id ASC").page(params[:page])

		
	end


 def import
    Contact.import(params[:file])
    redirect_to root_url, notice: "All contacts imported."
  end

	def edit
		@contact = Contact.find(params[:id])
		@seq_memberships = @contact.sequencememberships
	end

	def show
		if current_user
		    @contact = Contact.find(params[:id])
		    respond_to do |format|
		        format.js # actually means: if the client ask for js -> return file.js
		    end
		else
		    flash[:danger] = "Please Login First."
		    redirect_to new_user_session_path
  	end   

	end

	def create
		account = current_user.account
		@contact = account.contacts.build(params[:contact])
		if @contact.save
			queue  = @contact.build_queued
			queue.save!
			if params[:contact][:sequence_id].present? && params[:contact][:step_id].present?
				# params[:contact][:step_id]
				# contact = Contact.find(params[:contact_id])
				sequence_membership = Sequencemembership.new
				sequence_membership.contact_id = @contact.id
				sequence_membership.status = GlobalConstants::SM_ACTIVE #"active"
				sequence_membership.sequence_id = params[:contact][:sequence_id]
				sequence_membership.step_id = params[:contact][:step_id]
				sequence_membership.save!
				@step = Step.find(params[:contact][:step_id])
				if @step.step_number == 1 && @step.delay == 0
					ContactMailer.instant_emails(@contact,@step,account).deliver
					history = @contact.history || @contact.build_history
                    history.save!
                    sequence = Sequence.find(@step.sequence_id)
                    sentemail = history.sentemails.build
                    sentemail.email_id = Email.find_by_step_id(@step.id).id
                    sentemail.sequence_id = sequence.id
                    sentemail.step_id = @step.id
                    sentemail.date  = DateTime.now  
                    sentemail.save!
					# send_email(@step,@contact)    # call member method
					step = sequence.steps.where(:step_number=>2).first
					if step.present?
						nextemail = @contact.queued.nextemails.build
						nextemail.email_id = Email.find_by_step_id(step.id).id
						nextemail.step_id = step.id
						nextemail.sequence_id = sequence.id
						delay = step.delay
						schedule = step.schedule
						nextemail.status = GlobalConstants::NE_QUEUED #"queued"
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
						nextemail.sequencemembership_id = sequence_membership.id
						nextemail.save!
					end
				else
					nextemail = @contact.queued.nextemails.build
					nextemail.email_id = Email.find_by_step_id(params[:contact][:step_id]).id
					nextemail.step_id = params[:contact][:step_id]
					nextemail.sequence_id = params[:contact][:sequence_id]
					delay = @step.delay
					schedule = @step.schedule
					nextemail.status = GlobalConstants::NE_QUEUED #"queued"
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
					nextemail.sequencemembership_id = sequence_membership.id
					nextemail.save!
				end
				flash[:success]  = "Contact created successfully."
				redirect_to contacts_path
			elsif params[:contact][:sequence_id].present? && !params[:contact][:step_id].present?
				flash[:danger] = "Please select step"
				redirect_to edit_contact_path(@contact)
			elsif !params[:contact][:sequence_id].present? && params[:contact][:step_id].present?
				flash[:danger] = "Please select sequence"
				redirect_to edit_contact_path(@contact)
			else
				flash[:success] = "Contact created successfully"
				redirect_to contacts_path
			end
			# redirect_to sequencememberships_path({id: contact.id})
		else
			render :new
		end
	end

	def send_email(step,contact)
		require 'mandrill'
    	m = Mandrill::API.new(GlobalConstants::MANDRILL_KEY)
    	email = step.email
    	message = {
                :html => email.body,
                :text => email.body,
                :subject => email.subject,
                :from_email => current_user.account.try(:imapsetting).try(:email) || "CloseDeals@chimpchamp.com",
                :from_name => current_user.account.try(:imapsetting).try(:username) || "CloseDeals",
                :to => [{:email=>contact.primary_email}]
            }
        sending = m.messages.send message
	end

	def update
		account = current_user.account
		@contact = Contact.find(params[:id])
		if @contact.update_attributes(params[:contact])
			if params[:contact][:sequence_id].present? && params[:contact][:step_id].present?
				sequence_membership = Sequencemembership.new
				sequence_membership.contact_id = @contact.id
				sequence_membership.status = GlobalConstants::SM_ACTIVE #"active"
				sequence_membership.sequence_id = params[:contact][:sequence_id]
				sequence_membership.step_id = params[:contact][:step_id]
				sequence_membership.save!
				@step = Step.find(params[:contact][:step_id])
				if @step.step_number == 1 && @step.delay == 0
					ContactMailer.instant_emails(@contact,@step,account).deliver
					history = @contact.history || @contact.build_history
                    history.save!
                    sequence = Sequence.find(@step.sequence_id)
                    sentemail = history.sentemails.build
                    sentemail.email_id = Email.find_by_step_id(@step.id).id
                    sentemail.sequence_id = sequence.id
                    sentemail.step_id = @step.id
                    sentemail.date  = DateTime.now  
                    sentemail.save!
					# send_email(@step,@contact)    # call member method
					step = sequence.steps.where(:step_number=>2).first
					if step.present?
						nextemail = @contact.queued.nextemails.build
						nextemail.email_id = Email.find_by_step_id(step.id).id
						nextemail.step_id = step.id
						nextemail.sequence_id = sequence.id
						delay = step.delay
						schedule = step.schedule
						nextemail.status = GlobalConstants::NE_QUEUED #"queued"
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
						nextemail.sequencemembership_id = sequence_membership.id
						nextemail.save!
					end
				else
					nextemail = @contact.queued.nextemails.build
					nextemail.email_id = Email.find_by_step_id(params[:contact][:step_id]).id
					nextemail.step_id = params[:contact][:step_id]
					nextemail.sequence_id = params[:contact][:sequence_id]
					delay = Step.find(params[:contact][:step_id]).delay
					schedule = Step.find(params[:contact][:step_id]).schedule
					nextemail.status = GlobalConstants::NE_QUEUED #"queued"
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
					nextemail.sequencemembership_id = sequence_membership.id
					nextemail.save!
				end
				flash[:success] = "Updated successfully"
				redirect_to edit_contact_path(@contact)  #edit path
			elsif params[:contact][:sequence_id].present? && !params[:contact][:step_id].present?
				flash[:danger] = "Please select step."
				redirect_to :back
			elsif !params[:contact][:sequence_id].present? && params[:contact][:step_id].present?
				flash[:danger] = "Please select sequence."
				redirect_to :back
			else
				flash[:success] = "Contact updated successfully"
				redirect_to edit_contact_path(@contact)
			end
		else
			redirect_to :back
		end
	end

	def destroy
		@contact = Contact.find(params[:id])
		@contact.queued.nextemails.destroy_all if @contact.queued.nextemails.present?
		@contact.sequencememberships.destroy_all if @contact.sequencememberships.present?
		@contact.queued.destroy if @contact.queued.present?
		@contact.destroy
		flash[:success] = "Successfully deleted"
		redirect_to contacts_path
	end
end
