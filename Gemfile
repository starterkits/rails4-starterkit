source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks' # https://github.com/rails/turbolinks
gem 'jbuilder', '~> 1.2' # https://github.com/rails/jbuilder

gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
# gem 'omniauth-twitter'
# gem 'omniauth-linkedin'

gem 'simple_form', '~> 3.0.0.rc'
# gem 'country_select'
gem 'addressable'

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
  gem 'pry'
  gem 'quiet_assets'
  # gem 'guard-rspec'
end

group :development, :test do
  gem 'zeus'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'simplecov', require: false

  # gem 'rb-inotify' # linux
  gem 'rb-fsevent' # osx
end
