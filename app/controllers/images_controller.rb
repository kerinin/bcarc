class ImagesController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  show.before do
    @project = @image.project
    if @image == @project.images.last
      if @project.videos.count
        @next = @project.videos.first
      end
    else
      @next = @project.images[ @project.images.index(@image) + 1]
    end
    
    unless @image == @project.images.first
      @prev = @project.images[ @project.images.index(@image) - 1]
    end
  end
end
