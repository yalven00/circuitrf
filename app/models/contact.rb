class Contact < ActiveRecord::Base
	belongs_to :account
	has_many :sequencememberships
	has_one :queued
	has_one :history
	attr_accessible :company, :first_name, :last_name, :website, :primary_email,:email2, :email3, :email4, :custom1, :custom2, :custom3, :last_reply_date,:sequence_id,:step_id
	
	attr_accessor :sequence_id,:step_id
    
    # validates :first_name, :last_name, presence: true
    # , uniqueness: {case_sensitive: false}
    validates :primary_email, presence: true,:format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "format error",:multiline => true}

   
  def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    contact = find_by_id(row["id"]) || new
    contact.attributes = row.to_hash.slice(*accessible_attributes)
    contact.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Csv.new(file.path, nil, :ignore)
  when ".xls" then Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end



 
end
