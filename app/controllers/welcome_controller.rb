class WelcomeController < ApplicationController
  before_action :require_manager_login, only: :index
  
  layout "resource", only: :index
  
  def validate
    saml_response = saml_validation
=begin
    if params[:employee][:username] =~ (/^[a-z]+\.[a-z]+@orasi\.com$/) 
      params[:employee][:email] = params[:employee][:username]
      @employee = Employee.find_by(email: params[:employee][:email])
    else
      @employee = Employee.find_by(username: params[:employee][:username].downcase)
    end
=end

    @employee = Employee.find_by(username: saml_response.name_id)
=begin
    raise Exception, @employee.display_name
    
    unless @employee.present? && @employee.validate_against_ad(params[:employee][:password])
      additional_errors = @employee.blank? ? [] : @employee.errors.full_messages
      redirect_to :login, flash: {error: additional_errors+["Invalid username or password."]}
      return
    end
=end
    
    if @employee
      session[:current_user_id] = @employee.id
      Session.create(session_id: session[:session_id])
      if @employee.role == "Base"
        redirect_to view_employee_vacations_path(@employee)
      else
        redirect_to :root
      end
    else
      redirect_to :login, flash: {error: @employee.errors.full_messages}
    end
  end
  
  # "Delete" a login, aka "log the user out"
  def logout
    # Remove the user id from the session
    @_current_user = session[:current_user_id] = nil
    redirect_to :login
  end
  
  def login
=begin
    @employee = Employee.new
    
    @mybrowser = request.env['HTTP_USER_AGENT']
    @compatibility_mode = !(request.env['HTTP_USER_AGENT'] =~ /compatible/).nil?
    case @mybrowser
    when /Firefox/
      @browser_name = "Firefox"
    when /Chrome/
      @browser_name = "Chrome"
    when /MSIE\s*\d+\.0/
      @browser_name = /MSIE\s*\d+\.0/.match(@mybrowser)
    when /rv:11.0/
      @browser_name = "IE 11"
    end
=end

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def index
    @modal_title = "Add Consultant"
    @resource_for_angular = "employee"
  end
  
  def issue
    email = HelpMailer.comments_email(current_user.display_name,current_user.email,issue_params[:comments],issue_params[:type])
    email.deliver
    redirect_to :back, flash: {info: "#{issue_params[:type].capitalize} email sent."}
  end

  def search_employee
    
    if current_user && current_user.admin? && current_user.search_validate(search_params[:employee_email], search_params[:admin_password])
      redirect_to :back, flash: {info: "Employee's username: #{current_user.employee_searched_username}"}
    else
      redirect_to :back, flash: {error: 'Invalid employee email or admin password.'}
    end

  end

  def login_issue
    email = HelpMailer.login_help_email(login_issue_params[:name], login_issue_params[:email], login_issue_params[:comments])
    email.deliver
    redirect_to :back, flash: {info: 'Login issue email sent.'}
  end
  
  private 
  
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
    settings.assertion_consumer_service_url = "https://bluesource.orasi.com/auth/saml/callback"
    settings.issuer = "https://bluesource.orasi.com"
    settings.idp_sso_target_url = "https://adfs.orasi.com/adfs/ls/"
    settings.idp_cert_fingerprint = "DF:36:3E:72:B1:36:D8:8E:32:55:41:B8:92:39:A9:03:7C:08:8F:88"

    settings
  end
end
