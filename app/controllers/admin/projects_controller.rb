class Admin::ProjectsController < Admin::BaseController
  resource_controller
  
  actions :all
  
  cache_sweeper :project_sweeper
  
  create.wants.html { redirect_to edit_admin_project_path(@project,@plan) }
  update.wants.html { redirect_to params[:return_to] || edit_admin_project_path(@project,@plan) }
  destroy.wants.html { redirect_to admin_projects_path }
end
