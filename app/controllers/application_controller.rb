class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :set_locale
  before_action :set_session_expiry

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_session_expiry
    return if Rails.env.test?
    Session.sweep('24 hours')
    if session[:current_user_id].present? && Session.find_by(session_id: session[:session_id]).blank?
      @_current_user = session[:current_user_id] = nil
      redirect_to :login, flash: { error: I18n.t(:session_expired) } unless request.original_url == login_url
    end
  end

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
        redirect_to :back, flash: { error: I18n.t(:invalid_date) }
      end
    end
  end

  # Only allow whitelisted roles.
  def require_manager_login
    set_original_url

    if current_user.blank?
      redirect_to :login
    elsif !current_user.manager_or_higher?
      redirect_to view_employee_vacations_path(current_user)
    end
  end

  def require_login
    set_original_url

    if current_user.blank? || current_user.blank? && request.referer.blank?
      redirect_to :login
    end
  end

  def must_be_system_admin
    redirect_to :root, flash: { error: I18n.t(:invalid_privileges) } unless current_user.system_admin?
  end

  def set_original_url
    session[:original_url] = request.original_url if params[:format].blank?
  end
end
