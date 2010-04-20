class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  caches_action :show
  
  show.before do
    @projects = @tag.projects.ascend_by_priority
  end
end
