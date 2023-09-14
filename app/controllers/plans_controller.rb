class PlansController < ApplicationController
	before_filter :authenticate_user!
	def index
			@constant_plans = Constantplan.all
			@current_plan = current_user.account && current_user.account.plan#Plan.find_by_account_id(current_user.account.id)
	end
	
end
