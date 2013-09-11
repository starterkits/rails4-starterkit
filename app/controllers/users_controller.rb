class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def reset_password
    current_user.send_reset_password_instructions
    flash[:notice] = I18n.t 'devise.passwords.send_instructions'
    redirect_to edit_user_registration_path
  end

  def update_password
    @user.password = params[:user][:password]
    if @user.save
      sign_in @user, bypass: true
      flash[:notice] = I18n.t 'user.password.updated'
      redirect_to user_root_path
    else
      render :add_password
    end
  end
end
