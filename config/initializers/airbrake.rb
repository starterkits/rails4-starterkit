Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.host    = ENV['AIRBRAKE_HOST']
  config.port    = 443
  config.secure  = (config.port == 443)
end
