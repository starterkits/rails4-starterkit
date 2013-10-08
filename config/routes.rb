# Route prefixes use a single letter to allow for vanity urls of two or more characters
StarterKit::Application.routes.draw do
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
  devise_scope :user do
    get '/a/after' => 'users/registrations#after_auth', as: 'user_root'
  end
  get '/a' => redirect('/a/signup')

  # User
  resources :users, path: '/u', only: :show
  get '/home' => 'users#show', as: 'user_home'

  root 'pages#home'
end
