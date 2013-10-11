class Users::SessionsController < Devise::SessionsController
  include DeviseReturnToConcern

  def new
    @failed = params[:failed]
    @provider = params[:provider]
    return render 'failed' if @failed
    super
  end
end
