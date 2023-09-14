class AddPlanIdToBillingsubscriptions < ActiveRecord::Migration
  def change
  	add_column :billingsubscriptions, :plan_id, :integer
  end
end
