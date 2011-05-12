class Admin::WebcamImagesController < Admin::BaseController
  #after_filter :expire_show, :only => [:create, :update, :destroy]
  #after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  #after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  belongs_to :project

  #cache_sweeper :project_sweeper, :tag_sweeper
  
  def create
    create!{ edit_admin_project_webcam_image_path(@project,@webcam_image) }
  end

  def update
    update!{ edit_admin_project_webcam_image_path(@project,@webcam_image) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_project_webcam_images_path(@project) }
      format.js { render :nothing => true}
    end
  end
  
  private 
  
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page], :per_page => 200))
  end
  
  def expire_show
    expire_fragment(:controller => 'webcam_images', :action => 'show')
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
