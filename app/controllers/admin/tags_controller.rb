class Admin::TagsController < Admin::BaseController
  resource_controller
  
  actions :all
  
  create.wants.html { redirect_to edit_admin_tag_path(@tag) }
  update.wants.html { redirect_to edit_admin_tag_path(@tag) }
  destroy.wants.html { redirect_to admin_tags_path }
end
