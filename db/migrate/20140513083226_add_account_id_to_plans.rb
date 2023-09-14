class AddAccountIdToPlans < ActiveRecord::Migration
  def change
  	add_column :plans, :account_id, :integer
  end
end
