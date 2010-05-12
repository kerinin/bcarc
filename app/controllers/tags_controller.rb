class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  caches_action :show, :cache_path => Proc.new { |c| c.params.merge( {:version => c.read_fragment(:tags_version)} ).delete_if { |k,v| k.starts_with?('utm_') } }
    
  show.before do
    if params[:id]
      @projects = @tag.projects
    else
      @projects = Project.ascend_by_priority
      @all = true
    end
    
    response.headers['Cache-Control'] = "public, max-age=600"
  end
end
