# Load the Rails application.
require File.expand_path('../application', __FILE__)

env = File.expand_path('../env.rb', __FILE__)
load(env) if File.exists?(env)

# Initialize the Rails application.
StarterKit::Application.initialize!
