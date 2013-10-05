class Users::AuthController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!, only: :failure
  before_action :setup

  # Capture metrics and redirect
  def after_sign_up
    session.delete(:omniauth)
    @path = params[:path] || user_home_path
    @flow = :signup
    render 'after_login'
  end

  def after_login
    session.delete(:omniauth)

    # Force user to have a password
    # TODO: add config var to control this behavior
    return redirect_to add_password_user_path(current_user) if current_user.needs_password?

    # Clear out path stored by devise
    path = stored_location_for(current_user)
    path ||= user_home_path
    @path = path

    @flow = :login
  end

  # Generic auth failure page
  # /a/failure
  def failure
  end

  protected

  def setup
    # Clear flash message so it doesn't clutter the UI
    flash.clear
  end

end
