if defined? Airbrake
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API_KEY']
    config.host    = ENV['AIRBRAKE_HOST']
    config.port    = 443
    config.secure  = (config.port == 443)
    config.js_api_key = ENV['AIRBRAKE_JS_API_KEY']
  end
end
