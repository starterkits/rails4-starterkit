module DeviseReturnToConcern
  extend ActiveSupport::Concern

  # Amount of time in seconds allowed before cached return to path is ignored
  RETURN_TO_TIMEOUT = 600

  included do
    before_action :store_location!, only: :new
  end

  def store_location!
    if params[:return_to]
      session[:"#{resource_name}_return_to"] = params[:return_to]
      session[:"#{resource_name}_return_to_timestamp"] = Time.now.utc.to_i
    end
  end

  def after_sign_in_path_for(resource)
    url = stored_location_for(resource)

    # Ignore any request that originated over 10 minutes ago
    time = Time.now.utc.to_i - RETURN_TO_TIMEOUT
    req_time = session.delete(:"#{resource_name}_return_to_timestamp")
    url = nil if req_time && req_time < time

    url || user_root_path
  end
end
