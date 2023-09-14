class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :website
      t.string :primary_email
      t.string :email2
      t.string :email3
      t.string :email4
      t.string :custom1
      t.string :custom2
      t.string :custom3
      t.string :last_reply_date
      t.integer :account_id
      t.timestamps
    end
  end
end
