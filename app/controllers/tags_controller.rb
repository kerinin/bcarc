class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  show.before do
    @projects = @tag.projects.descend_by_priority
  end
end
