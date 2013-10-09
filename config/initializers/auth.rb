module StarterKit
  class AuthConfig < Settingslogic
    source "#{Rails.root}/config/auth.yml"
    namespace Rails.env
    load!
  end
end

OmniAuth.config.logger = Rails.logger
OmniAuth.config.path_prefix = '/o'

StarterKit::Application.config.middleware.use OmniAuth::Builder do
  StarterKit::AuthConfig.providers.each do |k, v|
    opts = (v.try(:[], 'oauth') || {}).symbolize_keys
    provider k, v['key'], v['secret'], opts
  end
end
