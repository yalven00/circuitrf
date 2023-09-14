class AddStepIdToEmail < ActiveRecord::Migration
  def change
  	add_column :emails, :step_id, :integer
  end
end
