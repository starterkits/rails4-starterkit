Airship::Application.routes.draw do

  post '/auth/:provider/callback' => 'oauth#create'
  match '/auth/failure' => 'oauth#auth_failure', via: [:get, :post]
  get '/auth/:provider' => 'oauth#passthru', as: 'provider_auth'
  get '/auth' => redirect('/a/signup')
  devise_for :users, path: '/a',
    controllers: {registrations: 'users/registrations', passwords: 'users/reset_password'},
    path_names: {sign_up: 'signup', sign_in: 'login', sign_out: 'logout'}
  get '/a' => redirect('/a/signup')
  get '/login/done' => 'users/auth#after_login', as: 'user_root'
  get '/signup/done/:id' => 'users/auth#after_sign_up', as: 'after_sign_up'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root 'home#index'
end
