class ProjectsController < ApplicationController
  resource_controller
  
  actions :show, :index
  
  show.before do
    if @project.images.count > 1
      @next = @project.images[1]
    elsif @project.videos.count
      @next = @project.videos[0]
    end
  end
end
