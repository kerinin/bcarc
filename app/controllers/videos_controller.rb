class VideosController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  show.before do
    @project = @video.project
    unless @video == @project.videos.last
      @next = @project.videos[ @project.videos.index(@video) + 1]
    end
    
    if @video == @project.videos.first
      if @project.images.count
        @prev = @project.images.last
      end
    else
      @prev = @project.videos[ @project.videos.index(@video) - 1]
    end
  end
end
