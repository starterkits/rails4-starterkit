class Users::RegistrationsController < Devise::RegistrationsController
  include DeviseReturnToConcern

  before_action :set_vars
  before_action :permit_params, only: [:create, :update]
  after_action :cleanup_oauth, only: [:create, :update]

  # Additional resource fields to permit
  # Devise already permits email, password, etc.
  SANITIZED_PARAMS = [:first_name, :last_name].freeze

  # GET /resource/sign_up
  def new
    check_for_existing_account
    super
  end

  # GET /resource/after
  # Redirect user here after login or signup action
  # Used to require additional info from the user like email address, agree to new TOS, etc.
  def after_auth
    # User should be already signed in by Devise
    # or in process of signing up via OAuth provider
    if signed_in?
      authenticate_scope!
    else
      build_resource({})
    end

    # Check if anything went wrong with OAuth
    # User will already be signed in if using username/password sign up
    if !signed_in? && @auth.blank?
      redirect_to new_user_registration_path

    # Check if resource is valid
    # Resource will not yet be saved if user is signing up with OAuth
    elsif resource.persisted? && resource.valid?
      path = after_sign_in_path_for(current_user)
      path = user_home_path unless valid_after_sign_in_path?(path)
      redirect_to path

    # Redisplay registration form with OAuth data for user to confirm
    else
      check_for_existing_account
      respond_with(resource, template: 'users/registrations/new')
    end
  end

  # POST /resource
  def create
    check_for_existing_account
    super
    @auth.save! if @auth.present? && resource.persisted?
  rescue ActiveRecord::ActiveRecordError => e
    resource.destroy
    sign_out(resource) if signed_in?
    report_error(e)
    flash.clear
    flash[:error] = I18n.t 'errors.unknown'
    redirect_to error_page_path
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
    devise_parameter_sanitizer.for(:account_update) << SANITIZED_PARAMS
  end

  def build_resource(*args)
    super
    if session[:omniauth].present?
      @auth ||= Authentication.build_from_omniauth(session[:omniauth])
      resource.authentications << @auth
      @auth.populate_names
      resource.reverse_merge_attributes_from_auth(@auth)
    end
    resource
  end

  # Override Devise method to disable current_password requirement
  def update_resource(resource, params)
    if resource.password_required?
      super
    else
      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
      end
      result = resource.update(params)
      clean_up_passwords resource
      result
    end
  end

  # Clear out omniauth session to prevent session bloat
  def cleanup_oauth
    session.delete(:omniauth) if resource.persisted?
  end

  def after_sign_up_path_for(resource)
    user_root_path
  end

  def check_for_existing_account
    @existing_account = false
    email = (resource.try(:email) or params[:user].try(:[], :email))
    if email.blank? and session[:omniauth].present?
      @auth = Authentication.build_from_omniauth(session[:omniauth])
      email = @auth.oauth_data[:email]
    end
    @existing_account = User.find_by_email(email.strip.downcase) if email
  end

  def set_vars
    @failed = params[:failed]
    @provider = params[:provider]
    @auth = nil
  end
end
