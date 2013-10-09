module StarterKit
  class AuthConfig < Settingslogic
    source "#{Rails.root}/config/auth.yml"
    namespace Rails.env
    load!
  end
end


# TODO: confirm that full_host is no longer needed in dev
# full_host = '' # set to url as needed
# OmniAuth.config.full_host = full_host if full_host.present?
OmniAuth.config.logger = Rails.logger
OmniAuth.config.path_prefix = '/o'

StarterKit::Application.config.middleware.use OmniAuth::Builder do
  StarterKit::AuthConfig.providers.each do |k, v|
    puts '!!!!!!!!!'
    puts k
    puts v
    opts = (v.try(:[], 'oauth') || {}).symbolize_keys
    provider k, v['key'], v['secret'], opts
  end
end
