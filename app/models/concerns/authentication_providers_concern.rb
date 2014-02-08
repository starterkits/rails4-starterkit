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
        Rails.application.config.auth.login_providers || Rails.application.config.auth.providers.keys
      else
        Rails.application.config.auth.providers.keys
      end
    end

    def allow_multiple_for?(provider)
      Rails.application.config.auth.allow_multiple.include? provider
    end

    def provider_name(provider)
      Rails.application.config.auth.providers[provider]['name']
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
      Rails.application.config.auth.providers[provider]['logout']
    end
  end
end
