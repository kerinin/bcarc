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
end
