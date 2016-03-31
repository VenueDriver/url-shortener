Rails.application.routes.draw do

  resources 'shortener/shortened_urls',
    as: 'shortener_shortened_urls',
    controller: 'urls',
    path: 'urls' do
    member do
      get 'expand'
    end
  end

  # For health checks.  Without explicitly specifying these routes as a
  # higher priority, the URL http://example.com/fitter_happier will be
  # interpreted as a short URL.
  match '/fitter_happier' => 'fitter_happier#index'
  match '/fitter_happier/site_check' => 'fitter_happier#site_check'
  match '/fitter_happier/site_and_database_check' => 'fitter_happier#site_and_database_check'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get '/:id' => "urls#expand"
  get 'api/update.:format' => 'new_url#api_update'
  post 'new_url/create.:format' => 'new_url#create'

  # You can have the root of your site routed with "root"
  root 'urls#index'

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
end
