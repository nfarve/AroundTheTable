Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :recipes
  resources :dashboard
  root to: "home#index"

  post 'recipes/query_forma' =>'recipes#forma'
  post 'recipes/query_formb' =>'recipes#formb'
  get 'recipes/querya/(:culture/:options)' =>'recipes#find_by_culture', as: :querya
  get 'recipes/queryb/(:name/:options)' =>'recipes#find_by_ingredients', as: :queryb
  get 'recipes/sort/:recipe/:sort_type/:current_state' =>'recipes#sort', as: :sort
  get 'surprise/' =>'recipes#surprise', as: :surprise
  get 'myfavorites/:id'=>'recipes#editFavorites', as: :edit_favorites
  get 'myfavorites/' =>'recipes#getFavorites', as: :myfavorites
  get 'recipes/' =>'recipes#index'


 


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
end
