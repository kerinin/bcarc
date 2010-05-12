class TagSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the Project model
  observe Tag

  def after_create(object)
    increment_counter
  end

  def after_update(object)
    increment_counter
  end

  def after_destroy(object)
    increment_counter
  end

  private
  
  def increment_counter
    write_fragment :tags_version, ( read_fragment(:tags_version).to_i + 1 )
  end
end