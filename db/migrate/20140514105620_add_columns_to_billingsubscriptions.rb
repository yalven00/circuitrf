class AddColumnsToBillingsubscriptions < ActiveRecord::Migration
  def change
  	add_column :billingsubscriptions, :subscriber_id, :string
  	add_column :billingsubscriptions, :customer_id, :string
  end
end
