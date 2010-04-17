class TagsController < ApplicationController
  resource_controller
  
  actions :show
  
  show.before do
    @projects = @tag.projects.descend_by_priority
  end
  
  private
  
  def object
    @object ||= end_of_association_chain.find_by_param!(param) unless param.nil?
    @object
  end
  
  def parent_object
    parent? && !parent_singleton? ? parent_model.find_by_param!(parent_param) : nil
  end
end
