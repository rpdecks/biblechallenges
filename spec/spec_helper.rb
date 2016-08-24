ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rubygems'
require 'capybara/rspec'
require 'shoulda/matchers'
require 'email_spec'
require 'sidekiq/testing'

Time.zone = 'UTC'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

# Disable Sidekiq will NOT process message
RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec::Expectations.configuration.warn_about_potential_false_positives = false

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    with.library :rails
  end
end

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

RSpec.configure do |config|

  #clears jobs in in worker array before each
  config.before(:each) do
    Sidekiq::Worker.clear_all
    ActionMailer::Base.deliveries.clear
  end

  # suppress error backtrace if related to rvm or rbenv
  config.backtrace_exclusion_patterns = [/\.rvm/, /\.rbenv/, /\.gem/]

  config.infer_spec_type_from_file_location! 
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.clean
  end

  config.before :suite do
    DatabaseCleaner.clean_with(:truncation, {except: %w[chapters verses]})
  end

  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation, {except: %w[chapters verses]}
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
    Timecop.return
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Include Factory Girl syntax to simplify calls to factories
  config.include FactoryGirl::Syntax::Methods

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = "random"
  config.include Devise::TestHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include Capybara::DSL

  # Include custom macros here
  config.include LoginMacros
  config.include CreationMacros
  config.include ControllerMacros, type: :controller
end
