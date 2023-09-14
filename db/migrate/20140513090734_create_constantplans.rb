class CreateConstantplans < ActiveRecord::Migration
  def change
    create_table :constantplans do |t|
      t.string :name
      t.integer :contacts
      t.integer :sequence
      t.integer :monthly_emails
      t.integer :price

      t.timestamps
    end
  end
end
