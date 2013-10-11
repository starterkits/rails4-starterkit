# Common helpers included in ApplicationController and ApplicationHelper
module CommonHelper
  include AuthenticationsHelper::Providers
  include DeviseRoutesHelper

  def cached_user_for_prompt(user = nil)
    if user.present?
      session[:cached_user_for_prompt] = user
    else
      session.delete(:cached_user_for_prompt)
    end
  end
end
