require 'addressable/uri'

class OauthController < ApplicationController
  class AuthError < Exception; end

  skip_authorization_check
  protect_from_forgery except: [:create]
  skip_before_action :authenticate_user!
  before_action :set_vars

  # omniauth passthru to use for route naming
  def passthru
    render :nothing, status: 404
  end

  def on_omniauth_failure(env)
    message_key = env['omniauth.error.type']
    origin = env['omniauth.origin'] || ''
    # todo: replace with path name now that this code is in a controller...
    new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{message_key}&origin=#{CGI.escape(origin)}"
    Rack::Response.new(['302 Moved'], 302, 'Location' => new_path).finish
  end

  # oauth callback
  def create
    #return render text: '<pre>' + request.env["omniauth.origin"].to_yaml + "\n\n" + request.env["omniauth.auth"].to_yaml + '</pre>'

    @auth = Authentication.unscoped.find_by_provider_and_proid(@provider, @omniauth['uid'])

    # check for possible orphaned authentication record
    if @auth && @auth.user.nil?
      @auth = @auth.destroy && nil
    end

    @auth.update_from_omniauth(@omniauth) if @auth

    # make sure session is cleared from any previous requests
    session.delete(:omniauth)
    session.delete(:cached_auth_for_display)

    # Account Merge
    # Auth credentials exist and user is logged in
    if @auth && user_signed_in? && @auth.user != current_user
      set_cached_user_for_prompt
      @flow = :merge
      handle_redirect(merge: new_user_merge_path(current_user))

    # Login
    # Auth credentials exist and user is not logged in
    elsif @auth && (@flow == :login || @flow == :signup)
      @flow = :login
      sign_in(@auth.user)
      handle_redirect(login: @origin, close_modal: true)

    # Failed Sign-up
    # Auth already exists so prompt user to login
    # elsif @auth && @flow == :signup
    #   @prompt = :login
    #   set_cached_user_for_prompt
    #   handle_redirect

    # Reconnecting Existing Account
    # Auth exists but we're not in login or signup flow
    elsif @auth
      @auth.import_data(true)
      remember_job_ids(@auth)
      handle_redirect

    # Connecting New Account
    # Auth credentials are new and the user is logged in
    elsif user_signed_in?
      @auth = Authentication.build_from_omniauth(@omniauth)
      current_user.authentications << @auth
      remember_job_ids(@auth)
      flash[:notice] = I18n.t 'accounts.connected'
      handle_redirect

    # Sign-up
    # Auth credentials are new and the user is not logged in
    else
      session[:omniauth] = @omniauth
      handle_redirect
    end

  rescue Exception => e
    report_omniauth_error(e)
    raise
  end

  def auth_failure
    report_omniauth_error(AuthError.new(params[:message]))
    handle_redirect(
      signup: new_user_registration_path(failed: params[:message], layout: @layout, provider: @provider),
      login: new_user_session_path(failed: params[:message], layout: @layout),
      connect: authentications_route(failed: params[:message]),
    )
  end

  protected

  def authentications_route(*args)
    (user_signed_in? ? user_authentications_path(current_user, *args) : nil)
  end

  def set_vars
    @omniauth = request.env['omniauth.auth'] || {}
    @origin   = request.env['omniauth.origin'].to_s.presence || params[:origin]
    u = Addressable::URI.parse(@origin)
    if u && (u.path == '/' || u.path.blank?)
      @origin = user_root_path(u.query_values)
    end
    origin_params = (@origin.present? ? CGI::parse(@origin.split('?').last) : {})
    @layout   = origin_params['layout'].to_a.first || params['layout']
    @popup    = ((origin_params['popup'].to_a.first || params['popup']) == '1' ? true : false)
    flow      = origin_params['flow'].to_a.first || params['flow']
    @flow     = flow.present? && flow.to_sym || nil
    @prompt   = nil
    @provider = @omniauth && @omniauth[:provider] || session && session[:oauth] && session[:oauth].first.first
    @provider = @provider.downcase if @provider.is_a?(String)
  end

  def handle_redirect(opts = {})
    opts.reverse_merge!(
      signup: new_user_registration_path(layout: @layout, after_oauth: true, prompt: @prompt, provider: @provider),
      login: new_user_session_path(layout: @layout, failed: 'no_account', provider: @provider),
      connect: authentications_route(failed: params[:message]),
    )

    @url = ((opts.include?(@flow) && opts[@flow].present?) ? opts[@flow] : @origin) || user_root_path
    if @popup
      @url.sub!('popup=1', '')
      @url.sub!('layout=popup', '')
      @url.sub!(/&?flow=\w*/, '')
      @url.sub!(/&{2,}/, '')
      @close_modal = opts[:close_modal]
      render 'auth/popup_callback', layout: 'popup'
    else
      redirect_to @url
    end
  end

  def set_cached_user_for_prompt
    @prompt_user = cached_user_for_prompt({
      auth_id:    @auth && @auth.id || nil,
      image_url:  @omniauth[:info][:image],
      name:       @omniauth[:info][:name] || @omniauth[:info][:first_name],
      provider:   @omniauth[:provider].downcase,
    })
  end

  # https://github.com/intridea/omniauth/issues/185
  def handle_unverified_request
    true
  end
end
