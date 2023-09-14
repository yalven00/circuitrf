class AddQueuedIdToNexemails < ActiveRecord::Migration
  def change
    add_column :nextemails, :queued_id, :integer
  end
end
