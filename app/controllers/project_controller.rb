class ProjectController < ApplicationController
  before_action :require_manager_login
  before_action :set_project, only: [:index, :edit]
  
  layout :set_layout
  
  def all
    @modal_title = "Add Project"
    @resource_for_angular = "project"
    respond_to do |format|
      format.json {render json: Project.all.to_json({
        include: [
          {:lead => {:only => [:id, :first_name,:last_name]}}
        ], only: [:id, :name, :status]})}
      format.html {render action: :all}
    end
  end
  
  def update
    project = Project.find(params[:id])
    project.update(project_params)
    if project.save
      redirect_to project, flash: {notice: "Project successfully updated."}
    else
      redirect_to :back, flash: {error: project.errors.full_messages.first}
    end
  end
  
  def add
    @project = Project.new
  end
  
  def new
    @project = Project.new(project_params)
    if @project.save
      redirect_to :back, flash: {notice: "Project saved successfully."}
    else
      redirect_to :back, flash: {error: @project.errors.full_messages.first}
    end 
  end
  
  private
  
  def set_project
    @project = Project.find(params[:id])
    @title = @project.name
  end
  
  def set_layout
    case action_name
    when "index"
      "view_resource"
    when "all"
      "resource"
    end
  end
  
  def project_params
    params.require(:project).permit(:name, :lead_id, :start_date, :end_date, :status) if current_user.is_upper_management?
  end
end
