class AddContstandPlanIdToPlan < ActiveRecord::Migration
  def change
  	add_column :plans, :constant_plan_id, :integer
  end
end
