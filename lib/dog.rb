class Dog 
  
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        breed TEXT
        )
        SQL
    
    DB[:conn].execute(sql) 
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL

    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed:row[2])
    dog
  end
  
  def save 
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
    
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      
      self
    end
  end
  
  def self.find_by_name
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name)
    Student.new_from_db(row[1])
  end
  
  def self.create(name:, breed:)
    Dog.new(name: name, breed: breed)
    dog.save
    dog
  end

end
