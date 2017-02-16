require_relative "../config/environment.rb"
# require 'active_support/inflector'
require 'interactive_record.rb'
require 'pry'

class Student < InteractiveRecord
	self.column_names.each do |col_name|
		attr_accessor col_name.to_sym
	end

	def col_names_for_insert
		self.class.column_names[1..-1].join(", ")
	end

	def values_for_insert
		values = []
		self.class.column_names.each do |col|
			values << "'#{send(col)}'"
		end
		values[1..-1].join(", ")
	end

	def table_name_for_insert
		self.class.table_name
	end

	def save
		sql = <<-SQL
		INSERT INTO #{table_name_for_insert} (#{col_names_for_insert})
		VALUES (#{values_for_insert})
		SQL
		DB[:conn].execute(sql)
		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
	end

	def self.find_by_name(name)
		sql = <<-SQL
		SELECT *
		FROM students
		WHERE name = ?
		SQL
		# binding.pry
		DB[:conn].execute(sql, name)
	end
# how do i insert #{table_name_for_insert}?? instead of hardcoding students

	def self.find_by(attr_hash)
		# binding.pry

		key = attr_hash.keys[0]

		if attr_hash[key].is_a? Integer
      		value = "#{attr_hash[key]}"
    	else
      		value = "'#{attr_hash[key]}'"
    	end

		sql = <<-SQL
		SELECT *
		FROM students
		WHERE #{key} = #{value}
		SQL
		DB[:conn].execute(sql)

	end


end
