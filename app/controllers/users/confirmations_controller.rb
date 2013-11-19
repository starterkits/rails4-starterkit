class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    self.resource = (current_user or resource_class.new)
  end

  def create
    if user_signed_in?
      Devise.paranoid = false
      params[resource_name] ||= {}
      params[resource_name][:email] = current_user.email
    end
    super
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    user_signed_in? and edit_user_registration_path or super
  end
end
