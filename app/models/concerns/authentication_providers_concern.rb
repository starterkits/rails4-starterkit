module Concerns::AuthenticationProvidersConcern
  extend ActiveSupport::Concern

  def provider_name
    self.class.provider_name(provider)
  end

  def logout_url
    self.class.logout_url(provider)
  end

  def username_for_display
    self.class.username_for_display(username, provider)
  end

  module ClassMethods
    def providers(type = :login)
      case type
      when :login
        StarterKit::AuthConfig.login_providers || StarterKit::AuthConfig.providers.keys
      else
        StarterKit::AuthConfig.providers.keys
      end
    end

    def allow_multiple_for?(provider)
      StarterKit::AuthConfig.allow_multiple.include? provider
    end

    def provider_name(provider)
      StarterKit::AuthConfig.providers[provider]['name']
    end

    def username_for_display(username, provider = nil)
      case provider.to_sym
      when :twitter
        "@#{username}"
      else
        username
      end
    end

    def logout_url(provider)
      StarterKit::AuthConfig.providers[provider]['logout']
    end
  end
end
