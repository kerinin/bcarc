class ImagesController < ApplicationController
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  
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
    
    #response.headers['Cache-Control'] = "public, max-age=6400"
  end
  
  private
  
  def expire_thumbnails
    expire_fragment "thumbnails_for_#{@project.id}"
  end
end
