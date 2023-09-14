class CreateSmtpsettings < ActiveRecord::Migration
  def change
    create_table :smtpsettings do |t|

      t.string :email
      t.string :username
      t.string :password
      t.string :server

      t.timestamps
    end
  end
end
