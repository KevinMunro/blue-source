class Department < ActiveRecord::Base
  has_many :sub_departments, class_name: "Department", dependent: :nullify
  belongs_to :parent_department, class_name: "Department", foreign_key: "department_id"
  has_many :top_level_employees, class_name: "Employee"
  
  validates :name, uniqueness: {case_sensitive: false}
  validate :department_id_not_equal_to_id
  
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
  
  def find_path_to_highest_department
    if self.parent_department.blank?
      return [self.id]
    end
    
    [self.id] + self.parent_department.find_path_to_highest_department
  end
  
  def department_id_not_equal_to_id
    if !department_id.blank? and !id.blank? and department_id == id
      errors.add(:base, "Department cannot be its own parent department.")
    end
  end
end
