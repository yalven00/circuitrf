class AddStepIdToSequencememberships < ActiveRecord::Migration
  def change
    add_column :sequencememberships, :step_id, :integer
  end
end
