class BillingsubscriptionsController < ApplicationController
	def index
		@constant_plan = Constantplan.find(params[:id])
		@Billingsubscription = Billingsubscription.new
	end

	def create
		require "stripe"
		Stripe.api_key = GlobalConstants::STRIPE_KEY
		constant_plan = Constantplan.find(params[:plan_id])
		@plan = current_user.account.plan#Plan.find_by_account_id(account.id)

		if !@plan.present?
			@plan = current_user.account.build_plan
			@billing = @plan.build_billingsubscription
		end
		@plan.constant_plan_id = params[:plan_id]
	    @plan.save!

	    billing = current_user.account.plan.billingsubscription
	    billing.assign_attributes(params[:billingsubscription])
	    temp = billing.card_number.to_s
		temp = temp[-4..-1]
		billing.card_number = temp.to_i
		billing.amount = constant_plan.price
		billing.save!

		if !billing.customer_id.present?
			responce = Stripe::Customer.create(
					:email => "#{current_user.email}",
				  	:card => "#{billing.token}", # obtained with Stripe.js
				  	:plan => "#{constant_plan.stripe_plan_id}"
			)

			billing.customer_id = responce['id']
			billing.subscriber_id = responce['subscription']['id']
			billing.save!
		else
			customer = Stripe::Customer.retrieve("#{billing.customer_id}")
			customer.subscriptions.retrieve("#{billing.subscriber_id}").delete()

			customer = Stripe::Customer.retrieve("#{billing.customer_id}")
			responce = customer.subscriptions.create(:plan => "#{constant_plan.stripe_plan_id}")

			billing.subscriber_id = responce['id']
			billing.save!
		end

	    flash[:success] = "Billing Subscription Completed"
	    redirect_to plans_path
	end

end
