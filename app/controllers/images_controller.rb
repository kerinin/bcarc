class ImagesController < ApplicationController
  resource_controller
  
  belongs_to :project
  
  actions :show
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.unshift( read_fragment("project_#{params[:project_id]}") ).delete_if { |k,v| k.starts_with?('utm_') } }
  cache_sweeper :project_sweeper
  
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
end
