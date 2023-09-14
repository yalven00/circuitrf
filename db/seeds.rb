# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	Account.create!(:name => "Free", :contacts => 50, :sequences => 1, :monthly_emails => 100, :price => 0)
	Account.create!(:name => "StartUp", :contacts => 100, :sequences => 3, :monthly_emails => 500, :price => 25)
	Account.create!(:name => "Business", :contacts => 500, :sequences => 5, :monthly_emails => 1000, :price => 45)
	Account.create!(:name => "Pro", :contacts => 1000, :sequences => 10, :monthly_emails => 5000, :price => 65)
	puts "==========="
	puts Account.all
	puts "==========="
	# Account.create(:name => "Enterpris", :contacts =>5000, :sequences => , :monthly_emails => 10000, :price => 85)


