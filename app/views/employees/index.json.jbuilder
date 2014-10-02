json.array!(@employees) do |employee|
  json.extract! employee, :id, :status
  json.first_name employee.first_name.capitalize
  json.last_name employee.last_name.capitalize
  json.display_name employee.display_name
  json.location employee.location
  json.title employee.e_title
  unless employee.e_manager_id.blank?
	  json.manager do
	    json.id employee.e_manager_id
	    json.first_name employee.e_manager_first_name.capitalize
	    json.last_name employee.e_manager_last_name.capitalize
	    json.display_name "#{employee.e_manager_first_name.capitalize} #{employee.e_manager_last_name.capitalize}"
	  end
  end
  json.project do
    current_project = employee.current_project_name
    if current_project.present?
      json.name current_project
      json.id employee.current_project_id
    else
      json.name 'Not billable'
      json.id nil
    end
  end
end
