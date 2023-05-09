# frozen_string_literal: true

# Application Mailer
class ApplicationMailer < ActionMailer::Base
  default from: "Sample App <#{ENV['SMTP_MAIL']}>"
  layout 'mailer'
end
