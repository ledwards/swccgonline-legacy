Swcccgonline::Application.routes.draw do |map|
  # Authenicated login plugin
  match  '/signup', :to => 'users#new', :as => :signup
  match  '/login', :to => 'sessions#new', :as => :login
  match '/logout', :to => 'sessions#destroy', :as => :logout
  match '/activate(/:activation_code)', :to => 'users#activate', :as => :activate
  match '/users/resend_activation_code', :to => 'users#resend_activation_code'
  
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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  root :to => "launch#index"

  # See how all your routes lay out with "rake routes"
  
  match '/settings', :to => 'users#settings'
  
  # Messages
  match '/m/welcome', :to => 'launch#index' #redirects if you don't specify an id for welcome
  
  match '/change_settings_panel', :to => 'users#change_settings_panel'
  match '/reset_password(/:reset_password_token)', :to => 'users#reset_password'
  match '/set_password(/:reset_password_token)', :to => 'users#set_password'
  
  # Post routes

  match '/blog_posts', :to => 'posts#index', :post_type_id => "1"
  match '/articles', :to => 'posts#index', :post_type_id => "2"
  match '/decklists', :to => 'posts#index', :post_type_id => "3"
  match '/tournament_reports', :to => 'posts#index', :post_type_id => "4"  
  
  match '/blog_posts/new', :to => 'posts#new', :post_type_id => "1"
  match '/articles/new', :to => 'posts#new', :post_type_id => "2"
  match '/decklists/new', :to => 'posts#new', :post_type_id => "3"
  match '/tournament_reports/new', :to => 'posts#new', :post_type_id => "4"  

  match '/blog_posts/show(/:id)', :to => 'posts#show'
  match '/articles/show(/:id)', :to => 'posts#show'
  match '/decklists/show(/:id)', :to => 'posts#show'
  match '/tournament_reports/show(/:id)', :to => 'posts#show'  

  match '/blog_posts/edit(/:id)', :to => 'posts#edit'
  match '/articles/edit(/:id)', :to => 'posts#edit'
  match '/decklists/edit(/:id)', :to => 'posts#edit'
  match '/tournament_reports/edit(/:id)', :to => 'posts#edit'  
  
  match '/blog_posts/tags(/:tag)', :to => 'posts#tags', :post_type_id => "1"
  match '/articles/tags(/:tag)', :to => 'posts#tags', :post_type_id => "2"
  match '/decklists/tags(/:tag)', :to => 'posts#tags', :post_type_id => "3"
  match '/tournament_reports/tags(/:tag)', :to => 'posts#tags', :post_type_id => "4"  

  match '/blogs', :to => 'blogs#index' 
  match '/blogs(/:login)', :to => 'blogs#show'
  #match '/users/:login', :controller => 'users', :action => 'show', :login => nil # this is currently handled by hackery in the controller
  
  # Resources
  
  resources :session, :controller => :sessions
  resources :comments
  resources :posts, :member => {:rate => :post} 
  resources :cards
  resources :card_filters
  resources :cards, :collection => {:auto_complete_for_card_name => :get }
  resources :users
  resources :decks

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match '/:controller(/:action(/:id))'
end
