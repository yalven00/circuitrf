class AddSequencemembershipIdToNextemails < ActiveRecord::Migration
  def change
    add_column :nextemails, :sequencemembership_id, :integer
  end
end
