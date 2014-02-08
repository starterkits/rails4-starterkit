module Rails::Application::Config
	class Settings < Settingslogic
	  source "#{Rails.root}/config/application.yml"
	  namespace Rails.env
	  load!
	end
end

Rails.application.config.settings = Rails::Application::Config::Settings
