Bcrails::Application.routes.draw do
  filter :locale, :include_default_locale => false
  
  resources :webcam_images

  root :to => "projects#index"

  # All projects
  get 'Work', :controller => :tags, :action => :show, :all => true
  get 'Work/All', :controller => :tags, :action => :show, :all => true

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
  
  get '/sitemap/web.xml', :controller => :sitemap, :action => :web, :as => :web_sitemap
  get '/sitemap/image.xml', :controller => :sitemap, :action => :image, :as => :image_sitemap
  get '/sitemap/geo.xml', :controller => :sitemap, :action => :geo, :as => :geo_sitemap
  get '/sitemap.xml', :controller => :sitemap, :action => :index, :as => :sitemap

  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get '/auth/new', :to => 'sessions#new'
end
