class AddColumnDateToNextemails < ActiveRecord::Migration
  def change
  	remove_column :nextemails, :date
  	add_column :nextemails,:date, :datetime
  end
end
