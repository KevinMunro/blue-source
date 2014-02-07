class CalendarController < ApplicationController
  def index
    @all_months = (1..12).collect {|month_no| [Date.new(2014,month_no,1).strftime("%B"), month_no]}
    unless params[:year].blank? or params[:month].blank?
      @starting_date = Date.new(params[:year].to_i,params[:month].to_i,1)
    else
      @starting_date = Date.current.change(day: 1)
    end
    @filter_types = ['all']
    @selected_filter_type = "all"
    
    unless current_user.subordinates.blank?
      @filter_types << 'direct'
      @selected_filter_type = 'direct' 
    end
    
    unless current_user.department.blank?
      @filter_types << 'department'
      @selected_filter_type = 'department'
    end
    
    unless params[:filter].blank?
      @selected_filter_type = params[:filter]
    end
    
    case @selected_filter_type
    when 'all'
      @pdo_times = Vacation.all
    when 'department'
      @pdo_times = Vacation.where(employee_id: current_user.department.employees.pluck(:id))
    when 'direct'
      @pdo_times = Vacation.where(employee_id: current_user.subordinates.pluck(:id))
    end
    
    @pdo_times = @pdo_times.where.not(status: "Pending").where("start_date >= ? and start_date <= ?",@starting_date.beginning_of_month,@starting_date.end_of_month)
  end
  
end
