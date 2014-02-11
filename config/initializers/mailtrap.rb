if ENV['MAILTRAP_HOST'].present?
  ManagerPortal::Application.config.action_mailer.delivery_method = :smtp
  ManagerPortal::Application.config.action_mailer.smtp_settings = {
    :user_name => ENV['MAILTRAP_USER_NAME'],
    :password => ENV['MAILTRAP_PASSWORD'],
    :address => ENV['MAILTRAP_HOST'],
    :port => ENV['MAILTRAP_PORT'],
    :authentication => :plain
  }
end