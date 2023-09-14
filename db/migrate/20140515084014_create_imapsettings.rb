class CreateImapsettings < ActiveRecord::Migration
  def change
    create_table :imapsettings do |t|
      t.string :email
      t.string :username
      t.string :password
      t.string :server
      t.integer :account_id

      t.timestamps
    end
  end
end
