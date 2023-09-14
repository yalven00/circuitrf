class ContactMailer < ActionMailer::Base
   default from: "from@example.com"
  

  def instant_emails(contact,step,account)
  	smtp_config = account.smtpsetting
  	@email = step.email

    subject = @email.subject
    @body = @email.body
    contact_array = ["#{contact.first_name}","#{contact.last_name}","#{contact.company}","#{contact.website}","#{contact.primary_email}","#{contact.email2}","#{contact.email3}","#{contact.email4}","#{contact.custom1}","#{contact.custom2}","#{contact.custom3}"]
    merge_tags = ["{{first_name}}","{{last_name}}","{{company}}","{{website}}","{{primary_email}}","{{email2}}","{{email3}}","{{email4}}","{{custom1}}","{{custom2}}","{{custom3}}"]
    merge_tags.each_with_index do |tag,index|
        subject = subject.gsub(tag,contact_array[index])
        @body = @body.gsub(tag,contact_array[index])
    end
    

	   ActionMailer::Base.smtp_settings.merge!({
	 	user_name: smtp_config.email,
    password: smtp_config.password,
		address: smtp_config.server
    })

  	mail(:to => contact.primary_email, :subject => subject, :from => smtp_config.email)#, delivery_method_options: delivery_options)
  end

  def test_setting(smtp_config)
  	ActionMailer::Base.smtp_settings.merge!({
	 	  user_name: smtp_config[:email],
      password: smtp_config[:password],
		  address: smtp_config[:server]
    })
    # //smtp_config[:email]
    # mail(:to => "", :subject => 'CloseDeals test email', :from => smtp_config[:email])#, delivery_method_options: delivery_options)
  end

  def cron_emails(contact,email,account)
    smtp_config = account.smtpsetting
    @email = email

    subject = @email.subject
    @body = @email.body
    contact_array = ["#{contact.first_name}","#{contact.last_name}","#{contact.company}","#{contact.website}","#{contact.primary_email}","#{contact.email2}","#{contact.email3}","#{contact.email4}","#{contact.custom1}","#{contact.custom2}","#{contact.custom3}"]
    merge_tags = ["{{first_name}}","{{last_name}}","{{company}}","{{website}}","{{primary_email}}","{{email2}}","{{email3}}","{{email4}}","{{custom1}}","{{custom2}}","{{custom3}}"]
    merge_tags.each_with_index do |tag,index|
        subject = subject.gsub(tag,contact_array[index])
        @body = @body.gsub(tag,contact_array[index])
    end

      ActionMailer::Base.smtp_settings.merge!({
        user_name: smtp_config.email,
        password: smtp_config.password,
        address: smtp_config.server
      })

     puts "pass action mailer setings"

    mail(:to => contact.primary_email, :subject => subject, :from => smtp_config.email)#, delivery_method_options: delivery_options)
    puts "email send"
  end
end
