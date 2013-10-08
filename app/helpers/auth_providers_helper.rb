# Helper methods for OAuth providers
module AuthProvidersHelper
  def auth_providers(type = :login)
    case type
    when :login
      StarterKit::AuthConfig.login_providers || StarterKit::AuthConfig.providers.keys
    else
      StarterKit::AuthConfig.providers.keys
    end
  end

  def auth_provider_name(provider)
    StarterKit::AuthConfig.providers[provider]['name']
  end

  def auth_provider_username_for_display(username, provider = nil)
    case provider.to_sym
    when :twitter
      "@#{username}"
    else
      username
    end
  end

  def auth_provider_logout_url(provider)
    StarterKit::AuthConfig.providers[provider]['logout']
  end
end