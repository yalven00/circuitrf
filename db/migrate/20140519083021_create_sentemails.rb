class CreateSentemails < ActiveRecord::Migration
  def change
    create_table :sentemails do |t|
      t.integer :email_id
      t.integer :sequence_id
      t.integer :step_id
      t.date :date
      t.integer :history_id

      t.timestamps
    end
  end
end
