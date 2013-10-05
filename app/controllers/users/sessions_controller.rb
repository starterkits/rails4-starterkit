class Users::SessionsController < Devise::SessionsController
  def new
    @failed = params[:failed]
    @provider = params[:provider]
    return render 'failed' if @failed
    super
  end
end
