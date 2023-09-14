class ChangeDatatypeOfFileds < ActiveRecord::Migration
  def change
  	remove_column :steps, :step_number
  	remove_column :steps, :delay
  	add_column :steps, :step_number, :integer
  	add_column :steps, :delay, :integer
  end
end
