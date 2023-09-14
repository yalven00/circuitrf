class AddAccountIdToSequences < ActiveRecord::Migration
  def change
  	add_column :sequences, :account_id, :integer
  end
end
