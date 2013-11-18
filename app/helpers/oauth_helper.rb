module OauthHelper
  # Store and retrieve user details in session.
  #
  # Primarily useful for caching user details during OAuth flows
  # before user has logged in.
  def cached_user_for_prompt(user = nil)
    if user.present?
      session[:cached_user_for_prompt] = user
    else
      session.delete(:cached_user_for_prompt)
    end
  end
end
