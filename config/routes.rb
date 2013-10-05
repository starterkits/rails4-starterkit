# Route prefixes use a single letter to allow for vanity urls of two or more characters
ExampleApp::Application.routes.draw do
  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'

  # OAuth
  # Route prefix set in config/initializers/auth.rb
  get '/o/:provider/callback' => 'oauth#create'
  get '/o/failure' => 'oauth#failure'
  get '/o/:provider' => 'oauth#passthru', as: 'provider_auth'
  get '/o' => redirect('/a/login')

  # Devise
  devise_for :users, path: '/a',
      controllers: {registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/reset_password'},
      path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  get '/a' => redirect('/a/login')

  # Auth
  get '/a/login/done' => 'users/auth#after_login', as: 'user_root'
  get '/a/signup/done/:id' => 'users/auth#after_sign_up', as: 'after_sign_up'
  get '/a/failure' => 'users/auth#failure', as: 'auth_failure'

  # User
  resources :users, path: '/u', only: :show do
    get :add_password, on: :member
    put :update_password, on: :member
  end
  get '/home' => 'users#show', as: 'user_home'

  root 'pages#home'
end
