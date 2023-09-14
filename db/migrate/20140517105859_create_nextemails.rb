class CreateNextemails < ActiveRecord::Migration
  def change
    create_table :nextemails do |t|
      t.integer :email_id
      t.integer :sequence_id
      t.integer :step_id
      t.string :status
      t.text :response
      t.datetime :date

      t.timestamps
    end
  end
end
