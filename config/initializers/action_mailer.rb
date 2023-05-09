# frozen_string_literal: true

# Set ActionMailer settings for development and production mode.

if %w[development production].include? ENV['RAILS_ENV']
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: ENV['SMTP_HOST'],
    port: ENV['SMTP_PORT'],
    domain: ENV['SMTP_DOMAIN'],
    user_name: ENV['SMTP_MAIL'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :login,
    enable_starttls_auto: true
  }
  ActionMailer::Base.default_url_options = { host: ENV['APPLICATION_HOST'] }
end
