class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  show.before do
    @projects = @tag.projects.descend_by_priority
  end
  
  private
  
  def object
    @object ||= end_of_association_chain.find_by_permalink!(param) unless param.nil?
    @object
  end
end
