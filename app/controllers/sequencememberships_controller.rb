class SequencemembershipsController < ApplicationController
	def index
		if current_user && current_user.account.sequences.present?
			@contact = current_user.account.contacts.find(params[:id])
			@seq_memberships = @contact.sequencememberships
			@sequence_membership = Sequencemembership.new
		else
			flash[:warning] = "First add sequences."
			redirect_to sequences_path
		end
	end

	# def get_step
	# 	sequence = current_user.account.sequences.find(params[:id])
	# 	steps = sequence.steps.order("step_number ASC")
	# 	return render :json=> steps

	# end

	def get_step
		sequence = current_user.account.sequences.find(params[:id])
		steps = sequence.steps.includes(:email).order("step_number ASC")
		updated_steps = []
		steps.each do |step|
			updated_steps << step.attributes.dup.merge({email_subject: step.email.subject}) 
		end
		return render :json=> updated_steps
		# steps = sequence.steps.order("step_number ASC")
		# return render :json=> steps
	end

	def get_email
		email = Email.find_by_step_id(params[:id])
		return render :json=> email
	end

	def create
		contact = Contact.find(params[:contact_id])
		sequence_membership = Sequencemembership.new(params[:sequencemembership])
		sequence_membership.contact_id = contact.id
		sequence_membership.status = GlobalConstants::SM_ACTIVE #active
		sequence_membership.save!
		nextemail = contact.queued.nextemails.build
		nextemail.email_id = Email.find_by_step_id(params[:sequencemembership][:step_id]).id
		nextemail.step_id = params[:sequencemembership][:step_id]
		nextemail.sequence_id = params[:sequencemembership][:sequence_id]
		delay = Step.find(params[:sequencemembership][:step_id]).delay
		nextemail.status = GlobalConstants::NE_QUEUED #"queued"
		nextemail.date = Date.today + delay.to_i.day
		nextemail.sequencemembership_id = sequence_membership.id
		nextemail.save!
		flash[:success]  = "Sequence membership created successfully."
		redirect_to sequencememberships_path({id: contact.id})
	end

	def change_status
		sequence_membership = Sequencemembership.find(params[:id])
		sequence_membership.status = params[:status]
		sequence_membership.save!
		nextemail = Nextemail.find_by_sequencemembership_id(params[:id])
		# nextemail = Nextemail.where(sequence_membership.sequence_id).first
		if params[:status] == GlobalConstants::SM_ACTIVE #"active"
			nextemail.status = GlobalConstants::NE_QUEUED #"queued"
		else
			nextemail.status = GlobalConstants::NE_CANCELED #"canceled"
		end
		nextemail.save!
		return render :text=>true
	end

	def destroy
		sequencemembership = Sequencemembership.find(params[:id])
		nextemail = Nextemail.find_by_sequencemembership_id(params[:id])
		nextemail.destroy if nextemail.present?
		contact = Contact.find(sequencemembership.contact_id)
		sequencemembership.destroy if sequencemembership.present?
		# redirect_to sequencememberships_path({id: id})
		flash[:success] = "Successfully deleted"
		redirect_to edit_contact_path(contact)
	end

end


