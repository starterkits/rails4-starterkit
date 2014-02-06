class AuthenticationsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource only: :destroy

  def index
    @failed = params[:failed]
    @return_to = user_authentications_path
    @authentications = @user.authentications.grouped_with_oauth
  end

  def destroy
    @authentication.destroy
    redirect_to user_authentications_path current_user
  end
end
