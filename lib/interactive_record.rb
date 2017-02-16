require_relative "../config/environment.rb"
# require 'active_support/inflector'
require 'pry'

class InteractiveRecord
	
	def initialize(options={})
		options.each do |key, value|
			self.send("#{key}=", value)
		end
	end

	def self.table_name
		"#{self.name.downcase}s"
		# prob dont need downcase since sql doesnt recognize case
	end

	def self.column_names
		DB[:conn].results_as_hash = true

		sql = "PRAGMA table_info('#{table_name}')"
		table_info = DB[:conn].execute(sql)
		column_names = []
		table_info.each do |row|
			column_names << row["name"]
		end
		column_names.compact
	end



end