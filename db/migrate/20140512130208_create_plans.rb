class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :contacts
      t.integer :sequences
      t.integer :monthly_emails
      t.integer :price

      t.timestamps
    end
  end
end
