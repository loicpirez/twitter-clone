# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bootsnap', '1.12.0', require: false
gem 'bootstrap-sass', '3.4.1'
gem 'importmap-rails', '1.1.0'
gem 'jbuilder', '2.11.5'
gem 'puma', '5.6.4'
gem 'rails', '7.0.4'
gem 'sassc-rails', '2.1.2'
gem 'sprockets-rails', '3.4.2'
gem 'stimulus-rails', '1.0.4'
gem 'turbo-rails', '1.1.1'

group :development, :test do
  gem 'debug', '1.5.0', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', require: false
  gem 'sqlite3', '1.4.2'
end

group :development do
  gem 'web-console', '4.2.0'
end

group :test do
  gem 'capybara', '3.37.1'
  gem 'guard', '2.18.0'
  gem 'guard-minitest', '2.4.6'
  gem 'minitest', '5.15.0'
  gem 'minitest-reporters', '1.5.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'selenium-webdriver', '4.2.0'
  gem 'webdrivers', '5.0.0'
end

group :production do
  gem 'pg', '1.3.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem.
# Uncomment the following line if you're running Rails
# on a native Windows system:
# gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bcrypt', '~> 3.1'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'faker', '2.21.0'
gem 'will_paginate', '3.3.1'

gem 'rubocop-rails', '~> 2.19', group: :development

gem 'rubocop-capybara', '~> 2.18', group: :development
gem 'rubocop-minitest', '~> 0.30.0', group: :development
gem "actionmailer", "~> 7.0"

gem "dotenv-rails", "~> 2.8"

gem "active_storage_validations", "~> 1.0"

gem "image_processing", "~> 1.12"
