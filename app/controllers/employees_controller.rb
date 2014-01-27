class EmployeesController < ApplicationController
  before_action :require_manager_login, except: [:view_vacation,:directory]
  before_action :set_user, only: [:show, :edit, :vacation, :update, :view_vacation]
  
  #Only manager of employee can edit vacation, employee info, or update info.
  before_action :check_manager_status, only: [:edit, :vacation, :update]
  
  #Manager of employee or employee can view themselves.
  before_action :check_employee_is_current_user_or_manager, only: [:show, :view_vacation, :update]
  
  #Validate date parameters.
  before_action :validate_start_date, only: [:create, :update]
  before_action :validate_roll_on_date, only: [:create, :update]
  before_action :validate_roll_off_date, only: [:create, :update]
  
  layout :set_layout
  
  def show
    if request.referer == root_url+"employee/vacation/#{@employee.id}"
      @prev_page = 3
    end
    @prev_page = 2 if flash[:project] == true
    
    respond_to do |format|
      format.json {render json: @employee}
      format.html
    end
  end
  
  def directory
    respond_to do |format|
      format.json {render json: all_employees_for_directory.to_json}
    end
  end
  
  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to :root, flash: {success: "Employee added successfully."}
    else
      redirect_to :root, flash: {error: @employee.errors.full_messages}
    end 
  end
  
  def index
    @modal_title = "Add Consultant"
    @resource_for_angular = "employee"
    respond_to do |format|
      format.json {
        render json: subordinates_hash.to_json
      }
      format.html
    end
  end
  
  def update
    if @employee.update(employee_params)
      redirect_to @employee, flash: {success: "Employee successfully updated.", project: !employee_params[:project_id].nil?}
    else
      redirect_to @employee, flash: {error: @employee.errors.full_messages.first}
    end
  end
  
  private
  
  def set_user
    @employee = Employee.find(params[:id])
    @title = @employee.display_name
  end
  
  def check_manager_status
    redirect_to :root unless current_user.above? @employee or current_user.admin?
  end
  
  def check_employee_is_current_user_or_manager
    redirect_to :root, flash: {error: "You do not have permission to view this employee."} unless current_user == @employee or current_user.above? @employee or current_user.is_upper_management?
  end
  
  def set_layout
    case action_name
    when "show"
      "view_resource"
    when "index"
      "resource"
    end
  end
  
  def validate_start_date
    validate_date(employee_params[:start_date]) unless employee_params[:start_date].blank?
  end
  
  def validate_roll_on_date
    validate_date(employee_params[:roll_on_date])
  end
  
  def validate_roll_off_date
    validate_date(employee_params[:roll_off_date])
  end
  
  def employee_params
    allowed_params = [:username, :first_name, :last_name, :project_id, :start_date, :office_phone, :level, :location, :department, :cell_phone, :email, :im_name, :im_client, :team_lead_id, :roll_on_date, :roll_off_date]
    allowed_params += [:role, :manager_id, :status, :additional_days] if current_user.is_upper_management?
    param_hash = params.require(:employee).permit(allowed_params)
    param_hash.each {|key,val| param_hash[key]=val.downcase if key=='first_name' or key=='last_name'} unless param_hash.blank?
  end
  
  def subordinates_hash
    current_user.all_subordinates.as_json({
    include: [
      {:manager => {:only => [:id,:first_name,:last_name]}}, 
      {:project => {:only => :name}}], 
    only: [:id, :first_name, :last_name, :role, :manager_id, :project_id, :location, :status]
  }).map do |e| 
      capitalize_names_and_projects(e)
    end
  end
  
  def all_employees_for_directory
    Employee.all.as_json({
      include: [
        {manager: {only: [:id,:first_name,:last_name]}}
      ],
      only: [:id, :first_name, :last_name, :department, :office_phone, :cell_phone, :im_name, :im_client]
    }).map do |e|
      capitalize_names_and_projects(e)
    end
  end
  
  def capitalize_names_and_projects(employee)
     employee = employee.merge("first_name"=>employee['first_name'].capitalize,
             "last_name"=>employee['last_name'].capitalize)
     employee = employee.merge("project"=>{"name"=>"Not billable"}) if employee['project'].blank?
     unless employee['manager'].nil?
       employee.merge("manager"=>employee['manager'].merge({
         "first_name"=>employee['manager']['first_name'].capitalize,
         "last_name"=>employee['manager']['last_name'].capitalize
       })) 
     else 
       employee 
     end 
  end
end
