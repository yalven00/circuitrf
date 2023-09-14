MakeSales::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  ActiveAdmin.routes(self)
  resources :users
  resources :contacts
  resources :accounts
  resources :imapsettings do
    collection do
      get :testing
    end
  end

  resources :smtpsettings

  resources :plans do 
    collection do
      get :upgrade
    end
  end
  resources :billingsubscriptions
  resources :sequencememberships do 
    collection do
      get :get_step
      get :get_email
      get :change_status
    end
  end


  resources :contacts do
    collection { post :import }
  end

  resources :sequences do 
    collection do
      get :add_sequence
    end
  end
  resources :steps do 
    collection do
      get :add_step
      get :edit_step
      get :get_step
      get :count_step
    end
  end
  root :to => "static_pages#home" 
    # root :to => "users/sign_in"

  get '/users/:id/add_email' => 'users#add_email', via: [:get, :patch, :post, :put], :as => :add_user_email
  put '/users/:id/add_email' => 'users#add_email', :as => :add_user_email
  get '/contacts/import' => 'contacts#import', :as => :import
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
