class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :setup
  after_filter :handle_oauth_create, only: :create

  def create
    super
  rescue => e
    resource.destroy if resource && resource.persisted?
    flash.clear
    sign_out(resource)
    report_error(e)
    flash[:error] = I18n.t 'errors.unknown'
    redirect_to error_page_path
  end

  def delete
    redirect_to edit_user_path(current_user)
  end

  protected

  def build_resource(*args)
    super
    resource.tos_accepted_at = Time.now
    set_resource_fields(:email)
    set_resource_fields(:username, :nickname)
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
        remember_job_ids(auth)
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
