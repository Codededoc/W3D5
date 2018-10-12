require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    return @columns if @columns
    records = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    @columns = records.first.map! { |col| col.to_sym }

    # ...
  end


  def self.finalize!

    columns.each do |col|
      define_method(col) do
        attributes[col]
      end
    end
      # def col
      #   @attributes[col]
      # end

    columns.each do |col|
      define_method("#{col}=") do |value|
        attributes[col] = value
      end
      # def col=(value)
        #   @attributes[col] = value
        # end
    end
  end


  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name = self.name.downcase + "s"
  end

  def self.all

    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(results)
    # ...
  end

  def self.parse_all(results)
    objects = []
    results.each do |hash|
      objects << self.new(hash)
    end

    objects
    # ...
  end

  def self.find(id)

    self.all.each { |obj| return obj if obj.id == id }
    nil
    # ...
  end

  def initialize(params = {})

    params.each do |attr_name, value|
      attr_name = attr_name.to_sym

      raise "unknown attribute 'favorite_band'" unless self.class.columns.include?(attr_name)

      self.send("#{attr_name}=", value)
                #defined method  #*args
    end
    # ...
  end

  def attributes
    @attributes ||= {}
    # ...
  end

  def attribute_values

    self.attributes.values
    # ...
  end

  def insert
    col_names = self.columns.join(",")
    debugger
    question_marks = (["?"] * columns.count.length).join(",")

    DBConnection.execute(<<-SQL)
      INSERT INTO
        #{table_name}
      VALUES
        #{attribute_values}
    SQL

    DBConnection.last_insert_row_id
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
