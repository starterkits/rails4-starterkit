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
  provider :facebook, ENV['AUTH_FACEBOOK_KEY'], ENV['AUTH_FACEBOOK_SECRET']
  # StarterKit::AuthConfig.providers.each do |k, v|
  #   opts = (v.try(:[], 'oauth') || {}).symbolize_keys
  #   provider k, v['key'], v['secret'], opts
  # end

  on_failure do |env|
    ap env
    return
    message_key = env['omniauth.error.type']
    origin = env['omniauth.origin'] || ''
    new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{message_key}&origin=#{CGI.escape(origin)}"
    [302, {'Location' => new_path, 'Content-Type'=> 'text/html'}, []]
  end
  
end
