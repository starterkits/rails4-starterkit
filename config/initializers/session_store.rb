# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cache_store,
  { key: Rails.application.config.settings.session.key, expire_after: Rails.application.config.settings.session.expire_after }
