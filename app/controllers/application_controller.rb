class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise, require authenticate by default
  before_filter :authenticate_user!

  # CanCan, check authorization unless authorizing with devise
  check_authorization unless: :skip_check_authorization?

  :devise_controller?

  include CommonHelper
  include ErrorReportingConcern

  rescue_from CanCan::AccessDenied do |exception|
    path = user_signed_in? ? user_home_path : new_user_session_path
    redirect_to path, alert: exception.message
  end

  protected

  def skip_check_authorization?
    devise_controller? || is_a?(RailsAdmin::ApplicationController)
  end
end
