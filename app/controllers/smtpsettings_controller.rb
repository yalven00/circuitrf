class SmtpsettingsController < ApplicationController
	def create
		begin
			require "net/smtp.rb"
			
			smtp = Net::SMTP.new(params[:smtpsetting][:server],587)
			smtp.enable_starttls()
			smtp.start('domain.com',params[:smtpsetting][:email], params[:smtpsetting][:password], :plain)
			smtp.finish

			@smtp_setting = current_user.account.build_smtpsetting(params[:smtpsetting])
			@smtp_setting.save!
			redirect_to new_imapsetting_path
		rescue => ex
			flash[:danger] = ex.message
			redirect_to :back
		end
		
	end

	def update
		begin 
			require "net/smtp.rb"
			
			smtp = Net::SMTP.new(params[:smtpsetting][:server],587)
			smtp.enable_starttls()
			smtp.start('domain.com',params[:smtpsetting][:email], params[:smtpsetting][:password], :plain)
			smtp.finish

			smtpsetting = Smtpsetting.find(params[:id])
			smtpsetting.update_attributes(params[:smtpsetting])
			smtpsetting.save!
			redirect_to new_imapsetting_path
		rescue => ex
			flash[:danger] = ex.message
			redirect_to :back
		end
	end
end
