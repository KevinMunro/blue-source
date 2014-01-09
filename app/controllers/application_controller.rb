class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  private
 
  # Finds the Employee with the ID stored in the session with the key
  # :current_user_id This is a common way to handle user login in
  # a Rails application; logging in sets the session value and
  # logging out removes it.
  def current_user
    @_current_user ||= session[:current_user_id] &&
      Employee.find_by(id: session[:current_user_id])
  end
  
  def validate_date(date_param)
    unless date_param.blank?
      begin
        Date.parse(date_param)
      rescue
        redirect_to :back, flash: {error: "Date is invalid."}
      end
    end
  end
  
  # Only allow whitelisted roles.
  def require_manager_login
    if current_user.nil?
      redirect_to :login
    elsif !current_user.is_manager_or_higher?
      redirect_to view_vacation_path(current_user)
    end
  end
end
