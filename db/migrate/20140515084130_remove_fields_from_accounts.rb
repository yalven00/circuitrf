class RemoveFieldsFromAccounts < ActiveRecord::Migration
  def change
  	remove_column :accounts, :imap_email
  	remove_column :accounts, :imap_username
  	remove_column :accounts, :imap_password
  	remove_column :accounts, :imap_server
  end
end
