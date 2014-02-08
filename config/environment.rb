# Load the Rails application.
require File.expand_path('../application', __FILE__)
require File.expand_path('../settings', __FILE__)

# Set ENV vars to defaults in application.yml
Rails.application.config.settings.env.each do |k, v|
  ENV[k] ||= (v.blank? ? '' : v.to_s)
end

# Initialize the Rails application.
Rails.application.initialize!
