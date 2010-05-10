ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => :projects, :action => :index
  
  # Legacy routes
  map.connect 'Work/All', :controller => :tags, :action => :show
  map.connect 'Work/:id/*other', :controller => :tags, :action => :show
  
  # basic routes
  map.resources :projects, :as => 'Project' do |project|
    project.resources :images
    project.resources :videos
    project.resources :plans, :as => 'maps'
  end
  
  map.resources :tags, :as => 'Work'

  map.resources :pages, :as => 'Page'
  
  map.resources :plans, :as => 'Plan'
  
  # admin interface
  map.namespace :admin do |admin|
    admin.root :controller => :projects, :action => :index
    
    admin.resources :projects do |project|
      project.resources :images, :collection => {:sort => :post}
      project.resources :videos, :collection => {:sort => :post}
      project.resources :plans, :collection => {:sort => :post}
    end
    
    admin.resources :tags
    
    admin.resources :pages, :collection => {:sort => :post}
  end
  

  # Sitemaps
  
  map.web_sitemap '/sitemap/web.xml', :controller => :sitemap, :action => :web
  map.image_sitemap '/sitemap/image.xml', :controller => :sitemap, :action => :image
  map.video_sitemap '/sitemap/video.xml', :controller => :sitemap, :action => :video
  map.geo_sitemap '/sitemap/geo.xml', :controller => :sitemap, :action => :geo
  map.sitemap '/sitemap.xml', :controller => 'sitemap'


  # 404 (legacy) routes
  map.connect 'project/:id', :controller => :projects, :action => :show
  map.connect 'projects/:id', :controller => :projects, :action => :show
  map.connect 'Projects/:id', :controller => :projects, :action => :show
  
  map.connect 'project/:project_id/images/:id', :controller => :images, :action => :show
  map.connect 'projects/:project_id/images/:id', :controller => :images, :action => :show
  map.connect 'Projects/:project_id/Images/:id', :controller => :images, :action => :show
  
  map.connect 'project/:project_id/videos/:id', :controller => :videos, :action => :show
  map.connect 'projects/:project_id/videos/:id', :controller => :videos, :action => :show
  map.connect 'Projects/:project_id/Videos/:id', :controller => :videos, :action => :show
  
  map.connect 'project/:project_id/plans/:id', :controller => :plans, :action => :show
  map.connect 'projects/:project_id/plans/:id', :controller => :plans, :action => :show
  map.connect 'Projects/:project_id/Plans/:id', :controller => :plans, :action => :show
  
  map.connect '*glob', :controller => :application, :action => :legacy
  
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
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

#ActionController::Routing::Translator.i18n
