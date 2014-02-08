module Rails::Application::Config
  class Analytics < Settingslogic
    source "#{Rails.root}/config/analytics.yml"
    namespace Rails.env
    load!
  end
end

Rails.application.config.analytics = Rails::Application::Config::Analytics
