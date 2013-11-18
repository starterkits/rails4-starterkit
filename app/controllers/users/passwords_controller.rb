class Users::PasswordsController < Devise::PasswordsController
  prepend_before_action :force_logout, only: :edit

  protected

  # logout since devise will redirect to user home for logged in user instead of allowing them to edit password
  def force_logout
    sign_out(resource) if user_signed_in?
  end
end
