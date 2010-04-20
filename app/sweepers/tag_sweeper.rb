class TagSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the Project model
  observe Page

  def after_create(object)
    expire_page
    expire_action(:controller => :tags, :action => :show)
  end

  def after_update(object)
    expire_action(:controller => :tags, :action => :show, :id => record.to_param)
  end

  def after_destroy(object)
    expire_page
    expire_action(:controller => :tags, :action => :show)
  end
end
