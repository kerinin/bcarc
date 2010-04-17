ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => :projects, :action => :index
  
  map.resources :projects do |project|
    project.resources :images
    project.resources :videos
    project.resources :plans
  end
  
  map.resources :tags

  map.resources :pages
  
  map.resources :plans
  
  map.namespace :admin do |admin|
    admin.resources :projects do |project|
      project.resources :images
      project.resources :videos
      project.resources :plans
    end
    
    admin.resources :tags do |tag|
      tag.resources :projects
    end
    
    admin.resources :pages
  end
    
  # Legacy routes
  map.connect 'Work', :controller => :projects, :action => :index
  
  map.connect 'Project/:id', :controller => :projects, :action => :show
  map.connect 'Project/:project_id/images/:id', :controller => :images, :action => :show
  map.connect 'Project/:project_id/videos/:id', :controller => :videos, :action => :show
  
  map.connect 'Page/:id', :controller => :pages, :action => :show

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
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
