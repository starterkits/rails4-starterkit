module StarterKit
  class AnalyticsConfig < Settingslogic
    source "#{Rails.root}/config/analytics.yml"
    namespace Rails.env
    load!
  end
end
