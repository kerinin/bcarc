class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  show.before do
    if params[:id]
      @projects = @tag.projects
    else
      @projects = Project.ascend_by_priority
      @all = true
    end
    
    #response.headers['Cache-Control'] = "public, max-age=6400"
  end
end
