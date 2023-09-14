class AddStripePlanIdToConstantplans < ActiveRecord::Migration
  def change
  	add_column :constantplans, :stripe_plan_id, :string
  end
end
