require_relative "../config/environment.rb"

class Student
attr_accessor :name, :grade, :id 

def initialize(name, grade, id = nil)
  @name = name
  @grade = grade 
  @id = id
end 

def self.create_table
  sql = <<-SQL
  CREATE TABLE students( id INTEGER PRIMARY KEY,
  name TEXT, grade INTEGER)
  SQL
  DB[:conn].execute(sql)
 end 
 
 def self.drop_table
   sql = <<-SQL
   DROP TABLE students 
   SQL
   
   DB[:conn].execute(sql)
 end 

def save
  if self.id
  self.update
else
  sql = <<-SQL
  INSERT INTO students (name, grade) VALUES (?, ?)
  SQL
  
  DB[:conn].execute(sql, self.name, self.grade)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
end
end 

def self.create(name, grade)
  new_student = Student.new(name,grade)
  new_student.save 
  new_student
end

def self.new_from_db(row)
  id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
end

def self.find_by_name(name)
 sql = <<-SQL
 SELECT * FROM students WHERE name = ?
 SQL
row = DB[:conn].execute(sql, name).map |row|
 new_from_db(row)[0]
end

 def update
   sql = <<-SQL
   UPDATE students SET name = ?, grade = ? WHERE id = ?
   SQL
   DB[:conn].execute(sql, self.name, self.grade, self.id)
   
 end 

  
end
