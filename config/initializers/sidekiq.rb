# Modify size option to increase threads
# http://manuel.manuelles.nl/blog/2012/11/13/sidekiq-on-heroku-with-redistogo-nano/
# Current sizes of 1 and 2 are for RedisToGo Nano with a limit of 10 connections

if defined? Sidekiq
  redis_url = ENV['REDIS_URL']

  Sidekiq.configure_server do |config|
    config.redis = {
      url: redis_url,
      namespace: 'workers',
      size: 2
    }
  end
  Sidekiq.configure_client do |config|
    config.redis = {
      url: redis_url,
      namespace: 'workers',
      size: 1
    }
  end

  class Sidekiq::Extensions::DelayedMailer
    sidekiq_options queue: :mailer, timeout: 20, retry: 3
  end
end
