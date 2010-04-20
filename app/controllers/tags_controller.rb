class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  show.before do
    @projects = @tag.projects.ascend_by_priority
  end
end
