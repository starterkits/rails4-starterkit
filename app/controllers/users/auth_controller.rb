class Users::AuthController < ApplicationController
  # todo: enable skip when cancan is installed
  #skip_authorization_check
  before_filter :setup

  # capture metrics and redirect
  def after_sign_up
    session.delete(:omniauth)
    @path = params[:path] || user_home_path
    @flow = :signup
    render 'after_login'
  end

  def after_login
    session.delete(:omniauth)

    # force user to have a password
    return redirect_to add_password_user_path(current_user) if current_user.needs_password?

    # clear out path stored by devise
    path = stored_location_for(current_user)
    path ||= user_home_path
    @path = path

    @flow = :login
  end

  protected

  def setup
    # clear flash message so it doesn't clutter up the UI
    flash.clear
  end

end
