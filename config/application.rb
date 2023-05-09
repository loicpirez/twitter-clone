# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require 'dotenv/load'

require 'mini_magick'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

if %w[development production].include? ENV['RAILS_ENV']
  %w[SMTP_HOST SMTP_PORT SMTP_DOMAIN SMTP_MAIL SMTP_PASSWORD APPLICATION_HOST].each do |env_var|
    raise "Missing ENV['#{env_var}']" if ENV[env_var].blank?
  end
end

module SampleApp
  # Application config
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    MiniMagick.logger.level = Logger::DEBUG
    config.active_storage.variant_processor = :mini_magick

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
