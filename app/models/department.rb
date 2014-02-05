class Department < ActiveRecord::Base
  has_many :sub_departments, class_name: "Department" 
  belongs_to :parent_department, class_name: "Department", foreign_key: "department_id"
  has_many :top_level_employees, class_name: "Employee"
  
  def employees
    Employee.where(id: self.top_level_employees.pluck(:id) + sub_departments.map do |sub_dept|
      [sub_dept.top_level_employees.pluck(:id)] + sub_dept.employees
    end.flatten.uniq)
  end
  
  def above? other_department
    if other_department.blank?
      return false
    end
    
    if other_department == self
      return true
    end
    
    self.above? other_department.parent_department
  end
end
