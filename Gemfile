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
gem 'activerecord-import'
#gem 'chosen-rails'
gem 'thin'
gem 'sidekiq'
gem 'pickadate-rails'
gem 'font-awesome-rails'
gem 'redcarpet'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'activerecord-deprecated_finders'
gem 'acts_as_scriptural'
gem 'simple_token_authentication', '~> 1.0'
gem 'gretel'
gem 'figaro'
gem 'draper'
gem 'pg_search'
gem 'bootstrap_form'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rails_12factor'
  gem 'hirb'
end

group :development do
  gem 'mail_view'
  gem 'better_errors'
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
  gem 'spring-commands-rspec'
  gem 'shoulda-matchers', require: false
  gem 'pry'
  gem 'sqlite3'
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'heroku'
  gem 'factory_girl_rails', '4.1.0'
  gem 'rspec-rails'
  gem 'quiet_assets'
  gem 'annotate'
  gem 'timecop'
  gem 'rspec-collection_matchers'
  gem 'dotenv-rails'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'pry-nav'
end

group :test do
  # pretty print test output
  gem 'capybara'
  gem 'turn', :require => false
  gem 'simplecov', '0.5.4'
  gem 'faker', '~> 1.4.3'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'rspec-sidekiq'
  gem 'email_spec'
end

