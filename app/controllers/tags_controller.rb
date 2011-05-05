class TagsController < ApplicationController
  #resource_controller
  
  #actions :show, :index
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.merge( {:version => c.read_fragment(:tags_version)} ).delete_if { |k,v| k.starts_with?('utm_') } }
  
  def show
    @tag = Tag.find(params[:id])
    
    unless params[:all]
      @projects = @tag.projects.by_priority
    else
      @projects = Project.active.by_priority
      @all = true
    end
    
    if params[:by] == 'location'
      if @projects.to_map.count > 0
        @projects = @projects.to_map
      
        @map = GMap.new( "map_div" )
        @map.control_init( :large_map => true )
      else
        params[:by] = nil
      end
    end
    
    response.headers['Cache-Control'] = "public, max-age=600"
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
