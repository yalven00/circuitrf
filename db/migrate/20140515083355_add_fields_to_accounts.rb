class AddFieldsToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :imap_email,:string
  	add_column :accounts, :imap_username,:string
  	add_column :accounts, :imap_password,:string
  	add_column :accounts, :imap_server,:string
  end
end
