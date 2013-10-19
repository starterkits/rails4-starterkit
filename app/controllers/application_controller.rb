class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise, require authenticate by default
  before_filter :authenticate_user!

  # CanCan, check authorization unless authorizing with devise
  check_authorization unless: :skip_authorization?

  include CommonHelper
  include ErrorReportingConcern

  # Skip authorization check for Devise and Admin controllers
  def skip_authorization?
    devise_controller? || self.class.to_s =~ /Admin::\w+Controller/
  end

  # Method called by ActiveAdmin if not authorized
  def access_denied(exception)
    report_error(exception)
    path = user_signed_in? ? user_home_path : new_user_session_path
    redirect_to path, alert: I18n.t('auth.not_authorized')
  end
end
