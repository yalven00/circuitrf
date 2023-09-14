class ChangeFieldFromSteps < ActiveRecord::Migration
  def change
  	remove_column :steps, :type
  	add_column :steps, :schedule, :integer
  end
end
