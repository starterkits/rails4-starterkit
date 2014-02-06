# config/unicorn.rb

if ENV['RAILS_ENV'] == 'development' or not ENV['RAILS_ENV']

  # development
  worker_processes 1
  listen 3000

else

  # production and staging
  worker_processes 3
  timeout 30
  preload_app true

  before_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
      Process.kill 'QUIT', Process.pid
    end

    # Comment out if running workers in separate processes via Procfile
    if defined? Sidekiq
      @sidekiq_pid ||= spawn("bundle exec sidekiq -C config/sidekiq.yml")
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  after_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end

end
