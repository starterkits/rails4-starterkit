# Route prefixes use a single letter to allow for vanity urls of two or more characters
StarterKit::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if defined? RailsAdmin

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/admin/jobs'

  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'

  # OAuth
  oauth_prefix = StarterKit::AuthConfig.omniauth.path_prefix
  get "#{oauth_prefix}/:provider/callback" => 'users/oauth#create'
  get "#{oauth_prefix}/failure" => 'users/oauth#failure'
  get "#{oauth_prefix}/:provider" => 'users/oauth#passthru', as: 'provider_auth'
  get oauth_prefix => redirect("#{oauth_prefix}/login")

  # Devise
  devise_prefix = StarterKit::AuthConfig.devise.path_prefix
  devise_for :users, path: devise_prefix,
    controllers: {registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/reset_password'},
    path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  devise_scope :user do
    get "#{devise_prefix}/after" => 'users/registrations#after_auth', as: 'user_root'
  end
  get devise_prefix => redirect('/a/signup')

  # User
  resources :users, path: '/u', only: :show
  get '/home' => 'users#show', as: 'user_home'

  # Dummy pages for testing
  get '/test' => 'pages#test'

  root 'pages#home'
end
