class Admin::PagesController < Admin::BaseController
  resource_controller
  
  actions :all
  
  create.wants.html { redirect_to edit_admin_page_path(@page) }
  update.wants.html { redirect_to edit_admin_page_path(@page) }
  destroy.wants.html { redirect_to admin_pages_path }
  
  def sort
    Page.all.each do |i|
      i.position = params["page-list"].index(i.id.to_s)+1

      i.save
    end
  end
  
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
