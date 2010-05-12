class VideosController < ApplicationController
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.merge( {:version => c.read_fragment("project_#{c.params[:project_id]}")} ).delete_if { |k,v| k.starts_with?('utm_') } }
  
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
