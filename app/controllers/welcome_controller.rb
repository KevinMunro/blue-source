class WelcomeController < ApplicationController
  before_action :require_manager_login, only: :index

  protect_from_forgery except: :validate

  layout 'resource', only: :index

  def validate
    if Rails.env.production?
      saml_response = saml_validation
      username = saml_response.name_id
    else
      username = login_params[:username]
    end

    @employee = Employee.find_by(username: username.downcase)

    if @employee.blank?
      redirect_to :login, flash: { error: I18n.t(:resource_not_found, resource: 'Employee') }
    else
      validate_and_redirect_employee
    end
  end

  # "Delete" a login, aka "log the user out"
  def logout
    # Remove the user id from the session
    clear_session

    if Rails.env.production?
      redirect_to ENV['BS_SIGN_OUT_URL']
    else
      redirect_to :login
    end
  end

  def login
    if Rails.env.production?
      saml_request = OneLogin::RubySaml::Authrequest.new
      redirect_to(saml_request.create(saml_settings))
      return
    end

    @employee = Employee.new
    @mybrowser = request.env['HTTP_USER_AGENT']
    @compatibility_mode = !(request.env['HTTP_USER_AGENT'] =~ /compatible/).nil?
    case @mybrowser
      when /Firefox/
        @browser_name = 'Firefox'
      when /Chrome/
        @browser_name = 'Chrome'
      when /MSIE\s*\d+\.0/
        @browser_name = /MSIE\s*\d+\.0/.match(@mybrowser)
      when /rv:11.0/
        @browser_name = 'IE 11'
    end
  end

  def index
    @modal_title = I18n.t(:add_consultant)
    @resource_for_angular = 'employee'
  end

  def issue
    email = HelpMailer.comments_email(current_user.display_name, current_user.email, issue_params[:comments], issue_params[:type])
    email.deliver
    redirect_to :back, flash: { info: "#{issue_params[:type].capitalize} email sent." }
  end

  def search_employee
    if current_user && current_user.admin? && current_user.search_validate(search_params[:employee_email], search_params[:admin_password])
      redirect_to :back, flash: { info: "Employee's username: #{current_user.employee_searched_username}" }
    else
      redirect_to :back, flash: { error: I18n.t(:invalid_employee_email_or_admin_password) }
    end
  end

  def login_issue
    email = HelpMailer.login_help_email(login_issue_params[:name], login_issue_params[:email], login_issue_params[:comments])
    email.deliver
    redirect_to :back, flash: { info: I18n.t(:login_issue_email_sent) }
  end

  private

  def clear_session
    @_current_user = session[:current_user_id] = nil
    session[:original_url] = nil
  end

  def login_params
    params.require(:employee).permit(:username)
  end

  def issue_params
    params.require(:issue).permit(:comments, :type)
  end

  def search_params
    params.require(:search).permit(:employee_email, :admin_password)
  end

  def login_issue_params
    params.require(:login_issue).permit(:name, :email, :comments)
  end

  def saml_validation
    response          = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    response
  end

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new
    settings.assertion_consumer_service_url = ENV['ASSERTION_CONSUMER_SERVICE_URL']
    settings.issuer = ENV['BS_ISSUER']
    settings.idp_sso_target_url = ENV['BS_IDP_SSO_TARGET_URL']
    settings.idp_cert_fingerprint = ENV['BS_IDP_CERT_FINGERPRINT']

    settings
  end

  def validate_and_redirect_employee
    if @employee.save
      session[:current_user_id] = @employee.id
      Session.create(session_id: session[:session_id])
      if @employee.role == 'Base'
        redirect_to session[:original_url] || view_employee_vacations_path(@employee)
      else
        redirect_to session[:original_url] || :root
      end
    else
      redirect_to :login, flash: { error: @employee.errors.full_messages }
    end
  end
end
