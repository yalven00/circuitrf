class SequencesController < ApplicationController
	before_filter :authenticate_user!
	def index
		# @sequences = Sequence.all
		@sequences = current_user.account.sequences
	end

	def new
		@sequence = Sequence.new
	end

	def add_sequence
		account = current_user.account
		@sequence = account.sequences.build
		@sequence.name = params[:name]
		@sequence.stop_toggle = params[:toggle]
		@sequence.save!
		return render :text => @sequence.id
	end


	def edit
		@sequence = Sequence.find(params[:id])
		contacts = current_user.account.contacts
		@sequence_membership_present = false
		contacts.each do |contact|
			if contact.sequencememberships.where(:sequence_id => @sequence.id,:status => "completed").first.present?
				@sequence_membership_present = true
			end
		end
	end

	def destroy
		sequence = Sequence.find(params[:id])
		sequence.steps && sequence.steps.each do |step|
			step.email.destroy if step.email.present?
		end
		sequence.steps.destroy_all if sequence.steps.present?
		sequence.destroy
		flash[:success] = "Successfully destroy"
		redirect_to sequences_path
	end
end
