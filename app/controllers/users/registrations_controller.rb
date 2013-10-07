class Users::RegistrationsController < Devise::RegistrationsController
  before_action :permit_params, only: :create

  # Additional resource fields to permit
  # Devise already permits email, password, etc.
  SANITIZED_PARAMS = [:first_name, :last_name].freeze

  # Fields to lookup and set from OAuth session data
  # See OmniauthConcern
  # First element is the field name followed by any number of fields
  # to try and lookup in session data. If only the first element is
  # present, it will also be used as the lookup key.
  LOOKUP_PARAMS = [
    [:email],
    [:first_name],
    [:last_name],
    [:image_url]
    # [:username, :username, :nickname]
  ].freeze

  # GET /resource/sign_up
  def new
    super
  end

  # GET /resource/after
  # Redirect user here after login or signup action
  # Used to require additional info from the user like email address, agree to new TOS, etc.
  def after_auth
    auth = nil
    # User should either be...
    # already signed in by Devise
    # or in process of signing up via OAuth provider
    unless signed_in?
      build_resource({})
      if after_oauth?
        # User has "authed "via OAuth but not via Devise
        # Show user a modified sign up form with prefilled OAuth data
        auth = Authentication.build_from_omniauth(session[:omniauth])
      else
        return redirect_to new_user_registration_path
      end
    end
    if resource.valid?
      path = stored_location_for(current_user)
      path ||= user_home_path
      redirect_to path
    else
      respond_with(resource, auth: auth)
    end
  end

  # POST /resource
  def create
    super
    create_auth if after_oauth? && resource.persisted?
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def delete
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  def permit_params
    devise_parameter_sanitizer.for(:sign_up) << SANITIZED_PARAMS
  end

  def build_resource(*args)
    super
    LOOKUP_PARAMS.each do |args|
      set_resource_fields(*args)
    end
    resource
  end

  # Set field from session or omniauth if available
  # Field may have been cached in the session during an OAuth or custom sign up flow
  def set_resource_fields(field, *lookup_fields)
    return unless resource[field].blank?
    lookup_fields = [field] if lookup_fields.blank?
    lookup_fields.each do |lf|
      # Add additional session lookup here if data was cached as part of a custom flow
      resource[field] = session[:omniauth].to_h[:info].to_h[lf].presence
    end
  end

  def after_oauth?
    session[:omniauth].present?
  end

  def create_auth
    auth = resource.authentications.build
    auth.update_from_omniauth(session[:omniauth])
    # clear out omniauth session regardless of how we got here to prevent session bloat
    session.delete(:omniauth)
  rescue ActiveRecordError => e
    # rollback registration if auth failed to get created
    resource.destroy
    sign_out(resource)
    report_error(e)
    flash.clear
    flash[:error] = I18n.t 'errors.unknown'
    redirect_to error_page_path
  end

  def after_sign_up_path_for(resource)
    path = after_sign_in_path_for(resource)
    if path == after_auth_path
      after_auth_path resource.id
    else
      after_auth_path resource.id, path: path
    end
  end
end
