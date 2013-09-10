auth_config = Airship::Application.config.oauth = {}

auth_config[:twitter] = {
  consumer_key: '@@OAUTH_TWITTER_APP_KEY@@',
  consumer_secret: '@@OAUTH_TWITTER_APP_SECRET@@',
  anywhere_key: '@@OAUTH_TWITTER_ANYWHERE_KEY@@'
}

auth_config[:facebook] = {
  consumer_key: '@@OAUTH_FACEBOOK_APP_KEY@@',
  consumer_secret: '@@OAUTH_FACEBOOK_APP_SECRET@@'
}

# Common Facebook scopes
# email
# user_about_me
# user_interests
# user_activities
# user_likes
# user_location
# user_website
# friends_about_me
# friends_interests
# friends_activities
# friends_likes
# friends_location

FACEBOOK_OAUTH_SCOPE = %w{
  email
}.join(',').freeze

auth_config[:linkedin] = {
  :consumer_key => "@@OAUTH_LINKEDIN_APP_KEY@@",
  :consumer_secret => "@@OAUTH_LINKEDIN_APP_SECRET@@"
}

auth_config[:google] = {
  :consumer_key => "@@OAUTH_GOOGLE_APP_KEY@@",
  :consumer_secret => "@@OAUTH_GOOGLE_APP_SECRET@@"
}

full_host = '@@KAPPA_OAUTH_FULL_PATH@@'
OmniAuth.config.full_host = full_host if full_host.present?

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, auth_config[:facebook][:consumer_key], auth_config[:facebook][:consumer_secret], scope: FACEBOOK_OAUTH_SCOPE
  provider :twitter, auth_config[:twitter][:consumer_key], auth_config[:twitter][:consumer_secret]
  provider :linkedin, auth_config[:linkedin][:consumer_key], auth_config[:linkedin][:consumer_secret]
  # provider :google, auth_config[:google][:consumer_key], auth_config[:google][:consumer_secret], \
  #   access_type: 'offline', approval_prompt: 'force', scope: 'https://www.google.com/m8/feeds,userinfo.email,userinfo.profile'

  on_failure do |env|
    message_key = env['omniauth.error.type']
    origin = env['omniauth.origin'] || ''
    new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{message_key}&origin=#{CGI.escape(origin)}"
    [302, {'Location' => new_path, 'Content-Type'=> 'text/html'}, []]
  end
end
