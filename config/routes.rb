# Route prefixes use a single letter to allow for vanity urls of two or more characters
ExampleApp::Application.routes.draw do
  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'

  # OAuth
  # Route prefix set in config/initializers/auth.rb
  get '/o/:provider/callback' => 'users/oauth#create'
  get '/o/failure' => 'users/oauth#failure'
  get '/o/:provider' => 'users/oauth#passthru', as: 'provider_auth'
  get '/o' => redirect('/a/login')

  # Devise
  devise_for :users, path: '/a',
      controllers: {registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/reset_password'},
      path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  get '/a/after' => 'users/registrations#after_auth', as: 'after_auth'
  get '/a' => redirect('/a/login')

  # Auth
  get '/a/login/done' => 'users/auth#after_login', as: 'user_root'
  get '/a/signup/done/:id' => 'users/auth#after_sign_up', as: 'after_sign_up'

  # User
  get '/home' => 'users#show', as: 'user_home'

  root 'pages#home'
end
