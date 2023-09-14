class RemoveAndAddColumnToEmail < ActiveRecord::Migration
  def change
  	remove_column :emails, :body
  	add_column :emails, :body, :text
  end
end
