class Users::SessionsController < Devise::SessionsController
  include DeviseReturnToConcern
  prepend_before_filter :force_reset_session, only: :destroy

  def new
    @failed = params[:failed]
    @provider = params[:provider]
    return render 'failed' if @failed
    super
  end

  def force_reset_session
    reset_session
  end
end
