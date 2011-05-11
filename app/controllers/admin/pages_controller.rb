class Admin::PagesController < Admin::BaseController
  cache_sweeper :page_sweeper
  
  def create
    create!{ edit_admin_page_path(@page) }
  end

  def update
    update!{ edit_admin_page_path(@page) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_pages_path }
    end
  end
  
  def sort
    Page.all.each do |i|
      i.position = params["page-list"].index(i.id.to_s)+1

      i.save
    end
  end
end
