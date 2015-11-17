class Admin::TagsController < Admin::BaseController
  after_filter :expire_show, :only => [:update, :destroy]

  cache_sweeper :tag_sweeper
  
  def create
    create!{ edit_admin_tag_path(@tag) }
  end

  def update
    update!{ edit_admin_tag_path(@tag) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_tags_path }
    end
  end
  
  private
  
  def expire_show
    expire_fragment "show_tag_#{params[:id] || :all}_by_"
    expire_fragment "show_tag_#{params[:id] || :all}_by_chronology"
    expire_fragment "show_tag_#{params[:id] || :all}_by_popularity"
  end
  
  def collection
    @tags = Tag
  end
end
