class AddColumnDateToSentemails < ActiveRecord::Migration
  def change
  	remove_column :sentemails, :date
  	add_column :sentemails,:date, :datetime
  end
end
