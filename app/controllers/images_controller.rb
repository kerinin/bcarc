class ImagesController < ApplicationController
  #resource_controller
  
  #belongs_to :project
  
  #actions :show
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.merge( {:version => c.read_fragment("project_#{c.params[:project_id]}")} ).delete_if { |k,v| k.starts_with?('utm_') } }
  
  def show
    @image = Image.find(params[:id])
    @project = @image.project
    if @image == @project.images.active.last
      if @project.videos.count
        @next = @project.videos.first
      end
    else
      @next = @image.active? ? @project.images.active[ @project.images.active.index(@image) + 1] : @project.images.active[1]
    end
    
    unless @image == @project.images.active.first || !@image.active?
      @prev = @project.images.active[ @project.images.active.index(@image) - 1]
    end
    
    response.headers['Cache-Control'] = "public, max-age=600"
        
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
