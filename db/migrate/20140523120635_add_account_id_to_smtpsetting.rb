class AddAccountIdToSmtpsetting < ActiveRecord::Migration
  def change
  	add_column :smtpsettings, :account_id, :integer
  end
end
