# Load the Rails application.
require File.expand_path('../application', __FILE__)
require File.expand_path('../settings', __FILE__)

# Set ENV vars to defaults in application.yml
unless Rails.env.production?
  StarterKit::Settings.env.each do |k, v|
    ENV[k] ||= v
  end
end

# Initialize the Rails application.
StarterKit::Application.initialize!
