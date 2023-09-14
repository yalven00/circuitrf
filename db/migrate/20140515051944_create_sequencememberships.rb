class CreateSequencememberships < ActiveRecord::Migration
  def change
    create_table :sequencememberships do |t|
      t.integer :contact_id
      t.integer :sequence_id
      t.string :status

      t.timestamps
    end
  end
end
