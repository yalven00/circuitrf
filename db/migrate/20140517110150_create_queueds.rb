class CreateQueueds < ActiveRecord::Migration
  def change
    create_table :queueds do |t|
      t.integer :contact_id

      t.timestamps
    end
  end
end
