class ChangeColumnDateFromNextemails < ActiveRecord::Migration
  def change
  	remove_column :nextemails, :date
  	add_column :nextemails, :date, :date
  end
end
