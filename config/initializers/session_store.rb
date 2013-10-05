# Be sure to restart your server when you modify this file.

ExampleApp::Application.config.session_store :cache_store,
  { key: '_exampleapp_session', expire_after: 30.minutes }

