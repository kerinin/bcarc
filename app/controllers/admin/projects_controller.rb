class Admin::ProjectsController < Admin::BaseController
  after_filter :expire_show, :only => [:update, :destroy]
  after_filter :expire_thumbnails, :only => [:destroy]
  after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  #resource_controller
  
  #actions :all
  
  cache_sweeper :project_sweeper, :tag_sweeper
    
  #create.wants.html { redirect_to edit_admin_project_path(@project,@plan) }
  #update.wants.html { redirect_to params[:return_to] || edit_admin_project_path(@project,@plan) }
  #destroy.wants.html { redirect_to admin_projects_path }
  
  def create
    create!{ edit_admin_project_path(@project) }
  end

  def update
    update!{ edit_admin_project_path(@project) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_projects_path }
    end
  end
  
  private
  
  def expire_show
    expire_fragment(:controller => 'projects', :action => 'show')
  end
  
  def expire_thumbnails
    expire_fragment "thumbnails_for_#{@project.id}"
  end
  
  def expire_tags
    @project.tags.each do |t|
      expire_fragment "show_tag_#{params[:id] || :all}_by_"
      expire_fragment "show_tag_#{params[:id] || :all}_by_chronology"
      expire_fragment "show_tag_#{params[:id] || :all}_by_popularity"
    end
  end
end
