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
    # opts = (v.try(:[], 'oauth') || {}).symbolize_keys
    #opts.merge!({client_options: {ssl: {ca_file: Rails.root.join('lib/assets/certs/cacert.pem').to_s}}})
    # opts.merge!({client_options: { ssl: {
    #   ca_file: '/usr/lib/ssl/certs/ca-certificates.crt',
    #   ca_path: "/etc/ssl/certs"
    # }}})
    # provider k, v['key'], v['secret'], opts
    provider :facebook, '1391555207746028', '518f4a8ae5229e8ed432f1cf6806b480', {client_options: { ssl: {
      ca_file: '/usr/lib/ssl/certs/ca-certificates.crt',
      ca_path: "/etc/ssl/certs"
    }}}
  end
end
