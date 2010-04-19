class Admin::PagesController < Admin::BaseController
  resource_controller
  
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
