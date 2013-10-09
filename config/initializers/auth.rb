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
  provider :twitter, 'suaKRakoutQv18PgRlGaw', 'lDOG2C6pkiSxV8RRon8leOj5ZLJeNoqLJziwfXhgtw'
  provider :facebook, '1391555207746028', '518f4a8ae5229e8ed432f1cf6806b480'
  # StarterKit::AuthConfig.providers.each do |k, v|
  #   opts = (v.try(:[], 'oauth') || {}).symbolize_keys
  #   provider k, v['key'], v['secret'], opts
  # end
end
