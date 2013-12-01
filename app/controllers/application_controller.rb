class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise, require authenticate by default
  before_filter :authenticate_user!

  # CanCan, check authorization unless authorizing with devise
  check_authorization unless: :skip_check_authorization?

  include CommonHelper
  include ErrorReportingConcern
  include AuthorizationErrorsConcern

  protected

  def skip_check_authorization?
    devise_controller? || is_a?(RailsAdmin::ApplicationController)
  end

  # Reset response so redirect or render can be called again.
  # This is an undocumented hack but it works.
  def reset_response
    self.instance_variable_set(:@_response_body, nil)
  end

  # Respond to uncaught exceptions with friendly error message during ajax requets
  rescue_from Exception do |e|
    if request.format == :js
      report_error(e)
      flash.now[:error] = Rails.env.development? ? e.message : I18n.t('errors.unknown')
      render 'layouts/uncaught_error.js'
    else
      raise
    end
  end
end
