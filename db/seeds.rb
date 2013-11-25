# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Build org chart.
acxiom = Project.create({name: "Acxiom"})
scottrade = Project.create({name: "Scottrade"})
absg = Project.create({name: "ABSG"})
davita = Project.create({name: "Davita"})

#Alissa
manager = Employee.create([{username: "alissa.taylor", first_name: "alissa", last_name: "taylor", role: "Manager"}])
employee = Employee.create([
  {username: "andrew.williams"},
  {username: "lewis.gordon"},
  {username: "leroy.davis"},
  {username: "jonathan.gordon"},
  {username: "maria.lao"},
  {username: "robert.meeks"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end
employee[0].update(project: scottrade)
employee[1].update(project: acxiom)
employee[2].update(project: scottrade)
employee[3].update(project: scottrade)
employee[4].update(project: absg)
employee[5].update(project: davita)

#Adam
manager = Employee.create([{username: "adam.thomas", first_name: "adam", last_name: "thomas", role: "Manager"}])
employee = Employee.create([
  {username: "waightstill.avery"},
  {username: "timothy.macior"},
  {username: "brent.monger"},
  {username: "nikki.eubanks"},
  {username: "timothy.ruckriegel"},
  {username: "stephen.king"},
  {username: "ethan.bell"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Perry
manager = Employee.create([{username: "perry.thomas", first_name: "perry", last_name: "thomas", role: "Manager"}])
employee = Employee.create([
  {username: "alfredo.gonzalez"},
  {username: "damien.storm"},
  {username: "daniel.mattice"},
  {username: "john.denny"},
  {username: "kia.tinsley"},
  {username: "matt.mitchell"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Projects
acxiom.update(lead: Employee.find_by(username: "adam.thomas"))
