# Manage OAuth flows
# OauthController handles the business logic for OmniAuth

require 'addressable/uri'

class Users::OauthController < ApplicationController
  class AuthError < Exception; end

  skip_authorization_check
  protect_from_forgery except: [:create]
  skip_before_action :authenticate_user!
  before_action :set_vars

  # OmniAuth passthru to use for route naming
  def passthru
    render :nothing, status: 404
  end

  # OAuth Callback
  def create
    # Uncomment to debug oauth response
    # return render partial: 'authentications/debug_omniauth'

    @auth = Authentication.unscoped.find_by_provider_and_proid(@provider, @omniauth['uid'])

    # Check for possible orphaned authentication record
    if @auth && @auth.user.blank?
      @auth.destroy
      @auth = nil
    end

    # Update auth with latest data
    @auth.update_from_omniauth(@omniauth) if @auth

    # make sure session is cleared from any previous requests
    session.delete(:omniauth)
    session.delete(:cached_auth_for_display)

    # Account Merge
    # Auth credentials exist and user is logged in.
    # Typical action is to prompt user to merge or switch accounts.
    if @auth && user_signed_in? && @auth.user != current_user
      set_cached_user_for_prompt
      @flow = :merge
      redirect_to new_user_merge_path(current_user)

    # Login
    # Auth credentials exist and user is not logged in
    elsif @auth && (@flow == :login || @flow == :signup)
      @flow = :login
      sign_in @auth.user
      redirect_to @origin

    # Reconnecting Existing Account
    # Auth exists and user is not in login or signup flow.
    # Used after prompting user to reimport data from a provider.
    # Typical action is to return user to origin; probably connect accounts page.
    elsif @auth
      flash[:notice] = I18n.t 'accounts.updated'
      redirect_to @origin

    # Connecting New Account
    # Auth credentials are new and the user is logged in.
    elsif user_signed_in?
      @auth = Authentication.build_from_omniauth(@omniauth)
      current_user.authentications << @auth
      flash[:notice] = I18n.t 'accounts.connected'
      redirect_to @origin

    # Sign-up
    # Auth credentials are new and the user is not logged in
    else
      session[:omniauth] = @omniauth
      # Do not log user in yet, redirect to after_auth so user
      # can fill in any additional registration requirements like email
      redirect_to default_redirect_path
    end

  rescue => e
    report_omniauth_error(e)
    raise
  end

  def failure
    report_omniauth_error(AuthError.new(params[:message]))
    url = case @flow
    when :login
      new_user_session_path(failed: params[:message], provider: @provider)
    when :signup
      new_user_registration_path(failed: params[:message], provider: @provider)
    when :connect
      authentications_route(failed: params[:message], provider: @provider)
    end
    if url
      redirect_to url
    else
      render 'authentications/failure'
    end
  end

  protected

  def authentications_route(*args)
    (user_signed_in? ? user_authentications_path(current_user, *args) : nil)
  end

  def default_redirect_path
    user_root_path flow: @flow
  end

  def set_vars
    @omniauth = request.env['omniauth.auth'] || {}
    @origin   = request.env['omniauth.origin'].to_s.presence || params[:origin]
    uri = Addressable::URI.parse(@origin)
    path = uri && uri.path.presence

    # Override origin url if home, sign up, or login pages
    @origin = default_redirect_path unless valid_after_sign_in_path?(path)

    flow      = request.env['omniauth.params'].try(:[], 'flow') || params['flow']
    @flow     = flow.present? && flow.to_sym || nil
    @provider = @omniauth && @omniauth[:provider] || session && session[:oauth] && session[:oauth].first.first
    @provider = @provider.downcase if @provider.is_a?(String)
  end

  def set_cached_user_for_prompt
    cached_user_for_prompt({
      auth_id:    @auth && @auth.id || nil,
      image_url:  @omniauth[:info][:image],
      name:       @omniauth[:info][:name] || @omniauth[:info][:first_name],
      provider:   @omniauth[:provider].downcase,
    })
  end

  # https://github.com/intridea/omniauth/issues/185
  # TODO: remove this if no longer needed; write tests first
  def handle_unverified_request
    true
  end
end
