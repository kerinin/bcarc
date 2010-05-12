class ProjectSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the Project model
  observe Project, Image, Video, Plan

  def after_create(object)
    expire_cache_for(object)
  end

  def after_update(object)
    expire_cache_for(object)
  end

  def after_destroy(object)
    expire_cache_for(object)
  end

  private
  
  def expire_cache_for(object)
    case record.class
    when Project
      expire_action :controller => :projects, :action => :index
      expire_action :controller => :projects, :action => :show, :id => object.to_param
      object.images.map {|i| expire_cache_for i}
      object.videos.map {|i| expire_cache_for i}
      object.plans.map {|i| expire_cache_for i}
      object.tags.map {|i| expire_cache_for t}
    when Image
      expire_action :controller => :projects, :action => :index
      expire_action :controller => :images, :action => :show, :id => object.to_param
    when Video
      expire_action :controller => :videos, :action => :show, :id => object.to_param
    when Plan
      expire_action :controller => :plans, :action => :show, :id => object.to_param
    end
  end
end
