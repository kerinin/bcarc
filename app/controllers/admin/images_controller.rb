class Admin::ImagesController < Admin::BaseController
  
  resource_controller
  
  belongs_to :project
  
  actions :all
  
  private
  
  def collection
    end_of_association_chain
  end
  
  def object
    @object ||= end_of_association_chain.find_by_param!(param) unless param.nil?
    @object
  end
  
  def parent_object
    parent? && !parent_singleton? ? parent_model.find_by_param!(parent_param) : nil
  end
end
