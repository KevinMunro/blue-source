class ProjectController < ApplicationController
  before_action :require_manager_login
  before_action :set_project, only: :index
  
  def all
    respond_to do |format|
      format.json {render json: Project.all.to_json({
        include: [
          {:lead => {:only => [:id, :first_name,:last_name]}}
        ], only: [:id, :name, :status]})}
      format.html {render action: :all}
    end
  end
  
  def index
  end
  
  def add
    @project = Project.new
  end
  
  def new
    @project = Project.new(project_params)
    if !@project.save
      render action: :add
    end 
  end
  
  private
  
  def set_project
    @project = Project.find(params[:id])
  end
  
  def project_params
    params.require(:project).permit(:name, :lead_id, :status)
  end
end
