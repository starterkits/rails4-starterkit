if defined?(Rack::Timeout)
  if Rails.env.production? || Rails.env.staging?
    Rack::Timeout.timeout = 20 # seconds
  else
    Rack::Timeout.unregister_state_change_observer(:logger)
  end

  # class TimeoutObserver
  #   def rack_timeout_request_did_change_state_in(env)
  #     # Report statistics here
  #   end
  # end
  # Rack::Timeout.register_state_change_observer(:to_observers, TimeoutObserver.new)
end
