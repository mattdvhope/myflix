# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/email/rspec'
require 'sidekiq/testing/inline' # Allows passing of rspec testing with ActionMailer::Base...(makes testing inline; allows for the '#delay' method in the controllers, etc while testing). Even though it is 'delayed' in actual usage, in the rspec testing, the delay will not be implemented, but rather the email will be sent inline with the rest of the code.
require 'vcr' # Use vcr to make the tests involving third-party APIs (i.e., in spec/models/stripe_wrapper_spec.rb) run faster by enabling them to not need to hit the remote API server.  Instead, it only hits the server once and then records all that in 'spec/cassettes/...' for use in future tests.  This vcr code here came from https://www.relishapp.com/vcr/vcr/v/2-9-0/docs/test-frameworks/usage-with-rspec-metadata

Capybara.server_port = 52662 # In 'test.rb', make sure the local host is 52662 --> config.action_mailer.default_url_options = { host: 'localhost:52662' } ... or another (preferably 5-digit port number; make sure whatever port number you choose is not being used already; only ports 1-65535 exist; most likely 5 digit ports will be available, especially if your port consists of random numbers).

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.ignore_localhost = true # After loading in gem 'selenium-webdriver', type this in. It will prevent vcr's default hook/default cassette-recording into http every request to the local host (see..  https://www.relishapp.com/vcr/vcr/v/2-3-0/docs/configuration/ignore-request).
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false # Make this 'false' when using: gem 'database_cleaner' and add features below from Avdi Grimm's blog. Also, after adding gem 'database_cleaner', you may have to delete some vcr cassettes b/c js (maybe) was not true before.

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.treat_symbols_as_metadata_keys_with_true_values = true # Use with vcr
  config.before(:suite) do # This line and down comes from:  http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
