class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  caches_action :show
  
  show.before do
    if params[:id]
      @projects = @tag.projects.ascend_by_priority
    else
      @projects = Project.ascend_by_priority
      @all = true
    end
  end
end
