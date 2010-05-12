class ProjectSweeper < ActionController::Caching::Sweeper
  # This sweeper is going to keep an eye on the Project model
  observe Project, Image, Video, Plan

  def after_create(object)
    increment_counter_for object
  end

  def after_update(object)
    increment_counter_for object
  end

  def after_destroy(object)
    increment_counter_for object
  end

  private
  
  def increment_counter_for(object)
    key = case object.class.name
    when 'Project'
      "project_#{object.to_param}"
    else
      "project_#{object.project.to_param}"
    end
    
    write_fragment key, ( read_fragment(key).to_i + 1 )
  end
end
