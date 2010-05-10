Mime::Type.register 'application/vnd.google-earth.kml+xml', :kml

class ProjectsController < ApplicationController
  resource_controller
  
  actions :show, :index
  
  index.before do
    @projects = Project.random( 6, :conditions => { :priority => 1..3 }).sort_by {rand}
  end
  
  show.before do
    if @project.images.count > 1
      @next = @project.images[1]
    elsif @project.videos.count
      @next = @project.videos[0]
    end
    
    #response.headers['Cache-Control'] = "public, max-age=6400"
  end
  
  def map
    load_object     # From resource_controller
    
    redirect_to project_path(@project) and return unless @project.latitude && @project.longitude
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true)
    @map.center_zoom_init([@project.latitude,@project.longitude],4)
    @map.overlay_init(GMarker.new([@project.latitude,@project.longitude],:title => @project.name, :info_window => @project.short))
    
    render :action => :map
  end
end
