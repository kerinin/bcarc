class VideosController < ApplicationController
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  caches_action :show
  cache_sweeper :project_sweeper
  
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
    
    #response.headers['Cache-Control'] = "public, max-age=6400"
  end
  
  private
  
  def expire_thumbnails
    expire_fragment "thumbnails_for_#{@project.id}"
  end
end
