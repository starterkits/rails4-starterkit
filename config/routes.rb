ExampleApp::Application.routes.draw do
  match '/error' => 'pages#error', via: [:get, :post], as: 'error_page'

  # OAuth
  post '/auth/:provider/callback' => 'oauth#create'
  match '/auth/failure' => 'oauth#auth_failure', via: [:get, :post]
  get '/auth/:provider' => 'oauth#passthru', as: 'provider_auth'
  get '/auth' => redirect('/a/signup')

  # User registration and login
  devise_for :users, path: '/a',
    controllers: {registrations: 'users/registrations', passwords: 'users/reset_password'},
    path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  get '/a' => redirect('/a/signup')
  get '/home' => 'users#show', as: 'user_home'
  get '/login/done' => 'users/auth#after_login', as: 'user_root'
  get '/signup/done/:id' => 'users/auth#after_sign_up', as: 'after_sign_up'

  # User
  resources :users, path: '/u', only: :show do
    get :add_password, on: :member
    put :update_password, on: :member
  end


  root 'pages#home'
end
