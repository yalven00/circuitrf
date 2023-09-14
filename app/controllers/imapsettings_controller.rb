class ImapsettingsController < ApplicationController
before_filter :authenticate_user!
	def new
		@user = current_user	
		@imap_setting = current_user.account && current_user.account.imapsetting || Imapsetting.new
		@smtp_setting = current_user.account && current_user.account.smtpsetting || Smtpsetting.new
	end

	def create
		require 'em-imap'
		account = current_user.account
	    flag = 0
	    begin
		    EM::run do
		    	c = ''
		    	client = EM::IMAP.new(params[:imapsetting][:server], 993, true)
			    client.connect.bind! do
			      c = client.login(params[:imapsetting][:email], params[:imapsetting][:password])
			    end.callback do
			      puts "Connected and logged in!"
			      flag = 1
			    end.errback do |error|
			      puts "Connecting or logging in failed: #{error}"
			      flash[:error] = "IMAP credentials are not correct"
			      flag = 0	
			    end.bothback do
		        	EM::stop
		    	end
		    end
		rescue => ex
			flash[:error] = ex.message
			flag = 0
		end

	    if flag == 0
	    	# flash[:error] = "IMAP credentials are not correct"
	    	redirect_to :back
	    else	    	
	    	flash[:success] = "Authenticated and saved successfully."
			@imapsetting = account.build_imapsetting(params[:imapsetting])
			if @imapsetting.save
				redirect_to new_imapsetting_path
			else
				@user = current_user
				@imap_setting = current_user.account && current_user.account.imapsetting || Imapsetting.new
				@smtp_setting = current_user.account && current_user.account.smtpsetting || Smtpsetting.new
				render :new
			end
	    end
	end


	def update
		require 'em-imap'
	    flag = 0
	    begin
		    EM::run do
		    	c = ''
		    	client = EM::IMAP.new(params[:imapsetting][:server], 993, true)
			    client.connect.bind! do
			      c = client.login(params[:imapsetting][:email], params[:imapsetting][:password])
			    end.callback do
			      puts "Connected and logged in!"
			      flag = 1
			    end.errback do |error|
			      puts "Connecting or logging in failed: #{error}"
			       flash[:error] = "IMAP credentials are not correct"
			       flag = 0	
			    end.bothback do
		        	EM::stop
		    	end
		    end
		rescue => ex
			flash[:error] = ex.message
			flag = 0
		end

	    if flag == 0
	    	# flash[:error] = "IMAP credentials are not correct"
	    	redirect_to :back
	    else	    	
	    	flash[:success] = "Authenticated and saved successfully."
			imapsetting = Imapsetting.find(params[:id])
			imapsetting.update_attributes(params[:imapsetting])
			redirect_to new_imapsetting_path
	    end
	end


	def testing
		require 'net/imap'
		imap = Net::IMAP.new('imap.gmail.com', 993, true)
		imap.login('faisal.bhatti@devsinc.com', 'fbsa4167729')
		imap.select('INBOX')
		mailIds = imap.search(['NEW'])
		mailIds.each do |id|
		  msg = imap.fetch(id, 'ENVELOPE')[0].attr['ENVELOPE']
		  id = msg.sender[0].mailbox
		  host = msg.sender[0].host
		  mail_id = id +"@"+ host
		  puts msg
		  puts msg.date
		  puts mail_id
		end 
		mailIds.each do |id|
		  msg = imap.fetch(id, 'RFC822')[0].attr['RFC822']
		end
	end

end
