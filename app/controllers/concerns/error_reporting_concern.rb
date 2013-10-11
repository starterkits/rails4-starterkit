module ErrorReportingConcern
  def report_omniauth_error(e)
    params['omniauth_data'] = session[:omniauth].presence || request.env['omniauth.auth']
    report_error(e)
  end

  def report_error(e)
    if defined?(Airbrake)
      notify_airbrake(e)
    else
      logger.error(e)
    end
  end
end
