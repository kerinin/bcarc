class PagesController < ApplicationController
  resource_controller
  
  actions :show
  
  private
  
  def object
    @object ||= end_of_association_chain.find_by_permalink!(param) unless param.nil?
    @object
  end
end
