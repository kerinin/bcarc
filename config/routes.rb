Bcrails::Application.routes.draw do
  filter :locale, :include_default_locale => false
  
  resources :webcam_images

  root :to => "projects#index"

  # All projects
  match 'Work', :controller => :tags, :action => :show, :all => true
  match 'Work/All', :controller => :tags, :action => :show, :all => true

  # basic routes
  resources :projects, :path => 'Project' do
    member do
      get :map
      get :webcam
    end
  
    resources :images, :path => 'Images'
    resources :videos
    resources :plans
  end

  resources :tags, :path => 'Work'

  resources :pages, :path => 'Page'

  #resources :plans, :path => 'Plan'

  # admin interface
  namespace :admin do
    root :to => 'projects#index'
    
    resources :projects do
      resources :images do
        collection do
          post :sort
        end
      end
      
      resources :videos do
        collection do
          post :sort
        end
      end
      
      resources :plans do
        collection do
          post :sort
        end
      end
      
      resources :webcam_images
    end
    
    resources :tags
    
    resources :pages do
      collection do
        post :sort
      end
    end
  end
  
  # Sitemaps
  
  match '/sitemap/web.xml', :controller => :sitemap, :action => :web, :as => :web_sitemap
  match '/sitemap/image.xml', :controller => :sitemap, :action => :image, :as => :image_sitemap
  #match '/sitemap/video.xml', :controller => :sitemap, :action => :video, :as => :video_sitemap
  match '/sitemap/geo.xml', :controller => :sitemap, :action => :geo, :as => :geo_sitemap
  match '/sitemap.xml', :controller => :sitemap, :action => :index, :as => :sitemap

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  match '/auth/new', :to => 'sessions#new'

=begin
  # 404 (legacy) routes
  map.connect 'project', :controller => :projects, :action => :index
  map.connect 'projects', :controller => :projects, :action => :index
  map.connect 'Projects', :controller => :projects, :action => :index

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
  map.connect 'Project/:project_id/maps/:id', :controller => :plans, :action => :show

  map.connect '*glob', :controller => :application, :action => :legacy
=end
end
