source 'https://rubygems.org'
ruby "2.2.1"

gem 'rails', '4.2.1'
gem 'haml'
gem 'pg'
gem 'haml-rails'
gem 'devise'
gem 'high_voltage'
gem 'simple_form'
gem 'bootstrap-datepicker-rails', '1.1.1.9'
gem 'bootstrap-switch-rails', '~> 3.0.0'
gem 'activerecord-import'
#gem 'chosen-rails'
gem 'thin'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidetiq'
gem 'airbrake', '~> 4.3.4'
gem 'sinatra', :require => nil #required for viewing sidekiq jobs in web interface
gem 'pickadate-rails'
gem 'font-awesome-rails'
gem 'redcarpet'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'activerecord-deprecated_finders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'acts_as_scriptural', '0.0.5'
gem 'simple_token_authentication', '~> 1.0'
gem 'gretel'
gem 'figaro'
gem 'draper'
gem 'pg_search'
gem 'bootstrap_form'
gem 'htmlentities'
gem 'react-rails'
gem 'google-instant-hangouts'
gem 'ruby_array_find_consecutive'
gem 'paperclip'
gem 'aws-sdk', '~> 1.6'
gem 'intercom-rails'
gem 'friendly_id'
gem 'mail_form'
gem 'exception_notification'
gem 'slack-notifier'
gem "autoprefixer-rails" #prefix styles for cross-browser
gem 'fastercsv'
gem 'rcv_bible', '~> 0.0.5'

#sortable table/link
gem 'ransack'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rack-timeout'
  gem 'rails_12factor'
  gem 'hirb'
end

group :development do
  gem 'mail_view'
  gem 'better_errors'
  gem 'letter_opener'
  gem 'letter_opener_web'
#  gem 'bullet'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'bootstrap-sass', '~> 3.0.2.0'
  gem 'bootswatch-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails', '~> 3.3.0'
  gem 'spring-commands-rspec'
  gem 'pry-byebug'
  gem 'sqlite3'
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'factory_girl_rails', '4.1.0'
  gem 'quiet_assets'
  gem 'annotate'
  gem 'timecop'
  gem 'rspec-collection_matchers'
  gem 'dotenv-rails'
end

group :test do
  # pretty print test output
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'turn', :require => false
  gem 'simplecov', '0.5.4'
  gem 'faker', '~> 1.4.3'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner', '~> 1.2.0'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'rspec-sidekiq'
  gem 'email_spec'
end
