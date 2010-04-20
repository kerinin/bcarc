class ProjectSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the Project model
  observe Project, Image, Video, Plan

  # If our sweeper detects that a Product was created call this
  def after_create(project)
    expire_cache_for(project)
  end

  # If our sweeper detects that a Product was updated call this
  def after_update(project)
    expire_cache_for(project)
  end

  # If our sweeper detects that a Product was deleted call this
  def after_destroy(project)
    expire_cache_for(project)
  end

  private
  def expire_cache_for(record)
    expire_page(:controller => :projects, :action => :show, :id => record.to_param )
    expire_page(:controller => :images, :action => :show, :project_id => record.to_param )
    expire_page(:controller => :videos, :action => :show, :project_id => record.to_param )
    expire_page(:controller => :plans, :action => :show, :project_id => record.to_param )
  
    if record.is_a?(Project)
      expire_action(:controller => :tags, :actions => :show)
    end
  end
end
