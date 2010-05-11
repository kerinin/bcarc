class Admin::TagsController < Admin::BaseController
  after_filter :expire_show, :only => [:update, :destroy]
  
  resource_controller
  
  actions :all
  
  create.wants.html { redirect_to edit_admin_tag_path(@tag) }
  update.wants.html { redirect_to edit_admin_tag_path(@tag) }
  destroy.wants.html { redirect_to admin_tags_path }
  
  private
  
  def expire_show
    expire_fragment "show_tag_#{@tag.id}_by_"
    expire_fragment "show_tag_#{@tag.id}_by_chronology"
    expire_fragment "show_tag_#{@tag.id}_by_popularity"
  end
end
