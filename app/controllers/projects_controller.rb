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
end
