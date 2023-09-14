class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :name
      t.boolean :stop_toggle

      t.timestamps
    end
  end
end
