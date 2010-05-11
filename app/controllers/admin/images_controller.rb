class Admin::ImagesController < Admin::BaseController
  after_filter :expire_show, :only => [:create, :update, :destroy]
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  resource_controller
  
  belongs_to :project
  
  actions :all
      
  create.wants.html { redirect_to edit_admin_project_image_path(@project,@image) }
  update.wants.html { redirect_to edit_admin_project_image_path(@project,@image) }
  destroy.wants.html { redirect_to admin_project_images_path(@project) }

  def sort
    @project = Project.find_by_param(params[:id])
    @project.images.each do |i|
      i.position = params["image-list"].index(i.id.to_s)+1

      i.save
    end
    
    render :nothing => true
  end
  
  private 
  
  def expire_show
    expire_fragment(:controller => 'images', :action => 'show')
    expire_fragment(:controller => 'projects', :action => 'show')
  end
  
  def expire_thumbnails
    expire_fragment "thumbnails_for_#{@project.id}"
  end
  
  def expire_tags
    @project.tags.each do |t|
      expire_fragment "show_tag_#{t.id}_by_"
      expire_fragment "show_tag_#{t.id}_by_chronology"
      expire_fragment "show_tag_#{t.id}_by_popularity"
    end
  end
end
