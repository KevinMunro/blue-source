class DepartmentsController < ApplicationController
  before_action :must_be_system_admin, except: %i(sub_departments employees)
  before_action :set_department, except: %i(new create)

  def sub_departments
    respond_to do |format|
      format.json
    end
  end

  def employees
    respond_to do |format|
      format.json
    end
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to admin_departments_path, flash: { success: t(:create_success, resource: resource_name) }
    else
      redirect_to :back, flash: { error: @department.errors.full_messages }
    end
  end

  def destroy
    if @department.destroy
      redirect_to admin_departments_path, flash: { success: t(:delete_success, resource: resource_name) }
    else
      redirect_to admin_departments_path, flash: { error: @department.errors.full_messages }
    end
  end

  def update
    if @department.update(department_params)
      redirect_to admin_departments_path, flash: { success: t(:update_success, resource: resource_name) }
    else
      redirect_to edit_department_path(@department), flash: { error: @department.errors.full_messages }
    end
  end

  def new
    @department = Department.new(department_id: params[:parent_dept])
  end

  private

  def set_department
    @department = Department.find(params[:department_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :back, flash: { error: t(:resource_not_found, resource: resource_name) }
  end

  def department_params
    params.require(:department).permit(:name, :department_id)
  end

  def resource_name
    'Department'
  end
end
