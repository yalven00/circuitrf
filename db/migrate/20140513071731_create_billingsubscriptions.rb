class CreateBillingsubscriptions < ActiveRecord::Migration
  def change
    create_table :billingsubscriptions do |t|
      t.string :amount
      t.string :billing_period

      t.timestamps
    end
  end
end
