class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def after_create(object)
    # Nuke the cache - pages show up in the header of everything
    ActionController::Base.cache_store.clear
  end

  def after_update(object)
    ActionController::Base.cache_store.clear
  end

  def after_destroy(object)
    ActionController::Base.cache_store.clear
  end
end
