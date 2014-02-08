module Rails::Application::Config
  class Auth < Settingslogic
    source "#{Rails.root}/config/auth.yml"
    namespace Rails.env
    load!
  end
end

Rails.application.config.auth = Rails::Application::Config::Auth

OmniAuth.config.logger = Rails.logger
OmniAuth.config.path_prefix = Rails.application.config.auth.omniauth.path_prefix

Rails.application.config.middleware.use OmniAuth::Builder do
  Rails.application.config.auth.providers.each do |k, v|
    opts = (v.try(:[], 'oauth') || {}).symbolize_keys
    opts.merge!({client_options: {ssl: {ca_file: Rails.root.join('lib/assets/certs/cacert.pem').to_s}}})
    provider k, v['key'], v['secret'], opts
  end
end
