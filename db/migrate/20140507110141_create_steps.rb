class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :step_number
      t.string :delay
      t.integer :sequence_id

      t.timestamps
    end
  end
end
