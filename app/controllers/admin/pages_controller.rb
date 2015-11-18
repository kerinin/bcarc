class Admin::PagesController < Admin::BaseController
  cache_sweeper :page_sweeper
  
  def index
    @pages = Page.all
  end

  def get
    @page = Page.find(params[:id])
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(page_params)
    @page.save!
    redirect_to edit_admin_page_path(@page)
  end

  def update
    @page = Page.find(params[:id])
    @page.update!(page_params)
    redirect_to edit_admin_page_path(@page)
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy!
    redirect_to admin_pages_path
  end
  
  def sort
    Page.all.each do |i|
      i.position = params["page-list"].index(i.id.to_s)+1

      i.save
    end
  end

  private

  def page_params
    params.require(:page).permit(
      :name, :position, :content
    )
  end
end
