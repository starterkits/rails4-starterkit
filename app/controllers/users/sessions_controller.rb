class Users::SessionsController < Devise::SessionsController
  include DeviseReturnToConcern

  def new
    @failed = params[:failed]
    @provider = params[:provider]
    if request.env.try(:[], 'warden.options').try(:[], :action) == 'unauthenticated'
      @failed_login = flash.alert
      flash.delete :alert
    end
    return render 'failed' if @failed
    super
  end
end
