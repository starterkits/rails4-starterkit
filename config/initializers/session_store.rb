# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cache_store,
  { key: StarterKit::Settings.session.key, expire_after: StarterKit::Settings.session.expire_after }
