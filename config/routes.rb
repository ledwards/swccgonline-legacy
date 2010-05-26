ActionController::Routing::Routes.draw do |map|
  
  # Authenicated login plugin
  map.signup  '/signup', :controller => 'users',   :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.connect '/users/resend_activation_code', :controller => 'users', :action => 'resend_activation_code'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "launch"

  # See how all your routes lay out with "rake routes"

  # Highest priority routes
  
  map.connect '/settings', :controller => "users", :action => "settings"
  
  # Messages
  map.connect '/m/welcome', :controller => 'launch' #redirects if you don't specify an id  
  
  map.connect '/change_settings_panel', :controller => "users", :action => "change_settings_panel"
  map.connect '/reset_password/:reset_password_token', :controller => "users", :action => "reset_password", :reset_password_token => nil
  map.connect '/set_password/:reset_password_token', :controller => "users", :action => "set_password", :reset_password_token => nil
  
  # Post routes

  map.connect '/blog_posts', :controller => 'posts', :action => 'index', :post_type_id => "1"
  map.connect '/articles', :controller => 'posts', :action => 'index', :post_type_id => "2"
  map.connect '/decklists', :controller => 'posts', :action => 'index', :post_type_id => "3"
  map.connect '/tournament_reports', :controller => 'posts', :action => 'index', :post_type_id => "4"  
  
  map.connect '/blog_posts/new', :controller => 'posts', :action => 'new', :post_type_id => "1"
  map.connect '/articles/new', :controller => 'posts', :action => 'new', :post_type_id => "2"
  map.connect '/decklists/new', :controller => 'posts', :action => 'new', :post_type_id => "3"
  map.connect '/tournament_reports/new', :controller => 'posts', :action => 'new', :post_type_id => "4"  

  map.connect '/blog_posts/show/:id', :controller => 'posts', :action => 'show', :id => nil
  map.connect '/articles/show/:id', :controller => 'posts', :action => 'show', :id => nil
  map.connect '/decklists/show/:id', :controller => 'posts', :action => 'show', :id => nil
  map.connect '/tournament_reports/show/:id', :controller => 'posts', :action => 'show', :id => nil  

  map.connect '/blog_posts/edit/:id', :controller => 'posts', :action => 'edit', :id => nil
  map.connect '/articles/edit/:id', :controller => 'posts', :action => 'edit', :id => nil
  map.connect '/decklists/edit/:id', :controller => 'posts', :action => 'edit', :id => nil
  map.connect '/tournament_reports/edit/:id', :controller => 'posts', :action => 'edit', :id => nil  
  
  map.connect '/blog_posts/tags/:tag', :controller => 'posts', :action => 'tags', :post_type_id => "1", :tag => nil
  map.connect '/articles/tags/:tag', :controller => 'posts', :action => 'tags', :post_type_id => "2", :tag => nil
  map.connect '/decklists/tags/:tag', :controller => 'posts', :action => 'tags', :post_type_id => "3", :tag => nil
  map.connect '/tournament_reports/tags/:tag', :controller => 'posts', :action => 'tags', :post_type_id => "4", :tag => nil  

  map.connect '/blogs', :controller => 'blogs', :action => 'index' 
  map.connect '/blogs/:login', :controller => 'blogs', :action => 'show', :login => nil
  #map.connect '/users/:login', :controller => 'users', :action => 'show', :login => nil # this is currently handled by ghetto in the controller
  
  # Resources
  
  map.resource :session, :controller => :sessions
  map.resources :comments
  map.resources :posts, :member => {:rate => :post} 
  map.resources :cards
  map.resources :card_filters
  map.resources :cards, :collection => {:auto_complete_for_card_name => :get }
  map.resources :users
  map.resources :decks
  
  # API
  map.connect '/api/card_lookup/:name', :controller => 'api', :action => 'card_lookup', :name => nil
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
    
end
