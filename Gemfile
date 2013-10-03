source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 4.0.0'
gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks' # https://github.com/rails/turbolinks
gem 'jbuilder'   # https://github.com/rails/jbuilder
gem 'rack-timeout', '~> 0.1.0beta'

gem 'devise'
gem 'cancan'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
# gem 'omniauth-linkedin'

gem 'simple_form'
# gem 'country_select'
gem 'addressable'
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass', branch: '3'
gem 'haml-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

group :development do
  gem 'quiet_assets'
  # gem 'guard-rspec'
  gem 'guard-rspec'
end

group :development, :test do
  # Zeus should be installed and run outside of bundler
  # gem 'zeus'

  gem 'rspec-rails'
  gem 'factory_girl_rails'

  gem 'debugger'
  gem 'pry'
  # gem 'pry-stack_explorer'
  # gem 'pry-rescue'
  gem "debugger-pry", :require => "debugger/pry"

  # Add save_and_open_page support to rspec
  # gem 'poltergeist' # alternative to webkit
  gem 'capybara-webkit'
  gem 'launchy'

  # Add debug support to javascript tests
  # gem 'capybara-firebug'
end

group :test do
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'simplecov', require: false

  # gem 'rb-inotify' # linux
  gem 'rb-fsevent' # osx
end
