class Users::RegistrationsController < Devise::RegistrationsController
  before_action :setup
  before_action :permit_params, only: :create
  after_action :handle_oauth_create, only: :create

  # Additional resource fields to permit
  # Devise already permits email, password, etc.
  SANITIZED_PARAMS = [:first_name, :last_name].freeze

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  rescue => e
    if resource
      resource.destroy if resource.persisted?
      sign_out(resource)
    end
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
  end

  def build_resource(*args)
    super
    set_resource_fields(:email)
    set_resource_fields(:first_name)
    set_resource_fields(:last_name)
    set_resource_fields(:image_url)
    # set_resource_fields(:username, :nickname)
    resource
  end

  def setup
    @modal =        @layout == 'modal'
    @prompt =       params[:prompt]
    @after_oauth =  params[:after_oauth] == 'true' && @prompt.blank?
    @failed =       params[:failed]
    @provider =     params[:provider]
    @prompt_user =  cached_user_for_prompt
  end

  # Set field from session or omniauth if available
  # Field may have been cached in the session during an OAuth or custom sign up flow
  def set_resource_fields(field, *lookup_fields)
    return unless resource[field].blank?
    lookup_fields = [field] if lookup_fields.blank?
    lookup_fields.each do |lf|
      resource[field] = if session[lf].present?
        session[lf]
      elsif session[:omniauth] && session[:omniauth][:info] && session[:omniauth][:info][lf].present?
        session[:omniauth][:info][lf]
      end
    end
  end

  def handle_oauth_create
    if resource.persisted?
      if @after_oauth && session[:omniauth]
        auth = resource.authentications.build
        auth.update_from_omniauth(session[:omniauth])
      end
      # clear out omniauth session regardless of how we got here to prevent session bloat
      session.delete(:omniauth)
    end
    true
  end

  def after_sign_up_path_for(resource)
    path = after_sign_in_path_for(resource)
    path = nil if path == user_root_path
    after_sign_up_path resource.id, path: path
  end
end
