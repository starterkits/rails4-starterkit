if defined? Devise::Async
  Devise::Async.setup do |config|
    # config.enabled = false
    config.backend = :sidekiq
    config.queue = :mailer
  end
end
