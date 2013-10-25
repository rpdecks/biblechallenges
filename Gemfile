source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'haml', '3.1.7'
gem 'pg', '0.17.0'
gem 'haml-rails', '0.4'
gem 'devise', '3.0'
gem 'high_voltage', '2.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


group :production do
  gem 'rails_12factor'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development, :test do
  gem 'sqlite3'
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'heroku'
  gem 'shoulda', '3.3.2'
  gem 'factory_girl_rails', '4.1.0'
  gem 'rspec-rails', '~> 2.7.0'
  gem 'guard-rspec', require: false
end

group :test do
  # pretty print test output
  gem 'turn', :require => false
  gem 'simplecov', '0.5.4'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
