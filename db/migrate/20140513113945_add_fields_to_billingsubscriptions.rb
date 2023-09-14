class AddFieldsToBillingsubscriptions < ActiveRecord::Migration
  def change
  	add_column :billingsubscriptions, :token, :string
  	add_column :billingsubscriptions, :finger_print, :string
  	add_column :billingsubscriptions, :card_number, :integer
  	add_column :billingsubscriptions, :card_code, :integer
  end
end
