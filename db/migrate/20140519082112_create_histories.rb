class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :contact_id

      t.timestamps
    end
  end
end
