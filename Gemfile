source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'sidekiq'
gem 'unicorn'
gem "sentry-raven"
gem 'paratrooper'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog' # For Amazon S3
gem 'stripe'
gem 'figaro' # creates the 'config/application.yml' file (in gitignore)
gem 'draper' # For using decorators

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver' # A test-runner for use with capybara when 'js: true' (when Javascript is used on the page that is being feature-tested).
  gem 'database_cleaner' # If we use 'selenium-webdriver' as the test-runner, then we need this gem to clean the db.
end