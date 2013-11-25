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

#Eric
manager = Employee.create([{username: "eric.trout", first_name: "eric", last_name: "trout", role: "Manager"}])
employee = Employee.create([
  {username: "andrew.wiley"},
  {username: "brandi.ray"},
  {username: "doris.johnson"},
  {username: "joey.lane"},
  {username: "robert.straughn"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Julia
manager = Employee.create([{username: "julia.walser", first_name: "julia", last_name: "walser", role: "Manager"}])
employee = Employee.create([
  {username: "greg.dorman"},
  {username: "jason.storm"},
  {username: "spenser.mattice"},
  {username: "yhung.mlo"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Jessica
manager = Employee.create([{username: "jessica.marshall", first_name: "jessica", last_name: "marshall", role: "Manager"}])
employee = Employee.create([
  {username: "brandon.fair"},
  {username: "erin.chipman"},
  {username: "howard.martin"},
  {username: "john.crawford"},
  {username: "john.martin"},
  {username: "john.porter"},
  {username: "katelyn.chumbley"},
  {username: "christine.stephenson"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Adam
manager = Employee.create([{username: "adam.huntley", first_name: "adam", last_name: "huntley", role: "Manager"}])
employee = Employee.create([
  {username: "andrew.dargatz"},
  {username: "justin.phlegar"},
  {username: "michael.simpkins"},
  {username: "preston.williamson"},
  {username: "michael.cummings"},
  {username: "lateef.livers"},
  {username: "barinuadum.bariyiga"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Hope
manager = Employee.create([{username: "hope.isley", first_name: "hope", last_name: "isley", role: "Manager"}])
employee = Employee.create([
  {username: "adley.haywood"},
  {username: "jamaica.powell"},
  {username: "jason.trogdon"},
  {username: "lily.powell"},
  {username: "maryum.lawson"}
  ])
employee.each do |e|
  first_name_,last_name_ = e.username.split(".")
  e.update(first_name: first_name_, last_name: last_name_, manager: manager.first, role: "Consultant")
end

#Projects
acxiom.update(lead: Employee.find_by(username: "adam.thomas"))

paul = Employee.create({username: "paul.wysosky", first_name: "paul", last_name: "wysosky", role: "Director"})
Employee.find_by(username: "alissa.taylor").update(manager: paul)
Employee.find_by(username: "adam.thomas").update(manager: paul)
Employee.find_by(username: "eric.trout").update(manager: paul)
Employee.find_by(username: "julia.walser").update(manager: paul)

kristi = Employee.create({username: "kristi.collins", first_name: "kristi", last_name: "collins", role: "Director"})
Employee.find_by(username: "perry.thomas").update(manager: kristi)
Employee.find_by(username: "adam.huntley").update(manager: kristi)
Employee.find_by(username: "jessica.marshall").update(manager: kristi)
Employee.find_by(username: "hope.isley").update(manager: kristi)


virginia = Employee.create({username: "virginia.vestal", first_name: "virginia", last_name: "vestal", role: "AVP"})
paul.update(manager: virginia)
kristi.update(manager: virginia)
