class ProjectsController < ApplicationController
  before_action :require_manager_login
  before_action :set_project, only: [:show, :edit, :update, :leads]
  
  before_action :validate_start_date, only: [:new, :update]
  before_action :validate_end_date, only: [:new, :update]
  before_action :update_leads, only: [:new, :update]
  
  layout :set_layout
  
  def show
    @all_leads = []
    @project.leads.each do |lead|
      @all_leads << lead.display_name unless lead.blank?
    end
    @all_leads = @all_leads.sort.join(", ")
  end
  
  def index
    @modal_title = "Add Project"
    @resource_for_angular = "project"
    respond_to do |format|
      format.json {render json: Project.all.to_json({
        include: [
          {:leads => {:only => [:id, :first_name,:last_name]}},
          {:client_partner => {:only => [:id, :first_name, :last_name]}}
        ], only: [:id, :name, :status]})}
      format.html {render action: :index}
    end
  end
  
  def leads
    respond_to do |format|
      format.json {render json: @project.leads.order(first_name: :asc), only: [:first_name,:last_name,:id]}
    end
  end
  
  def update
    if @project.update(project_params)
      redirect_to @project, flash: {success: "Project successfully updated."}
    else
      redirect_to :back, flash: {error: @project.errors.full_messages.first}
    end
  end
  
  def add
    @project = Project.new
  end
  
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to :back, flash: {success: "Project saved successfully."}
    else
      redirect_to :back, flash: {error: @project.errors.full_messages.first}
    end 
  end
  
  private
  
  def set_project
    @project = Project.find(params[:project_id] || params[:id])
    @title = @project.name
  end
  
  def set_layout
    case action_name
    when "show"
      "view_resource"
    when "index"
      "resource"
    end
  end
  
  def update_leads
    Employee.where(project_id: params[:id]).update_all(project_lead: false)
    return unless params[:project][:leads]
    params[:project][:leads].each do |lead_id|
      next if lead_id.blank?
      Employee.find(lead_id).update(project_id: params[:id], project_lead: true)
    end
  end
  
  def validate_start_date
    validate_date(project_params[:start_date])
  end
  
  def validate_end_date
    validate_date(project_params[:end_date])
  end
  
  def project_params
    params.require(:project).permit(:name, :start_date, :leads, :end_date, :status, :client_partner_id) if current_user.is_upper_management?
  end
end
