class Admin::ImagesController < Admin::BaseController
  after_filter :expire_show, :only => [:create, :update, :destroy]
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  #resource_controller
  
  belongs_to :project
  
  #actions :all

  cache_sweeper :project_sweeper, :tag_sweeper
      
  #create.wants.html { redirect_to edit_admin_project_image_path(@project,@image) }
  #update.wants.html { redirect_to edit_admin_project_image_path(@project,@image) }
  #destroy.wants.html { redirect_to admin_project_images_path(@project) }
  def create
    create!{ edit_admin_project_image_path(@project,@image) }
  end

  def update
    update!{ edit_admin_project_image_path(@project,@image) }
  end
  
  def destroy
    destroy! do |format|
      format.html { redirect_to admin_project_images_path(@project) }
    end
  end
  
  def sort
    @project = Project.find(params[:project_id])
    @project.images.active.each do |i|
      i.position = params["image-list"].index(i.id.to_s)+1

      i.save
    end
    
    render :nothing => true
  end
  
  def pull_flickr
    load_object         # From R_C
    
    begin
      @image.pull_data_from_flickr
      @image.save!
    rescue XMLRPC::FaultException
      flash[:error] = "Error pulling from Flickr! (#{$!})"
    end
    
    flash[:notice] = "Data pulled from Flickr!"
    redirect_to edit_admin_project_image_path(@image.project, @image)    
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
      expire_fragment "show_tag_#{params[:id] || :all}_by_"
      expire_fragment "show_tag_#{params[:id] || :all}_by_chronology"
      expire_fragment "show_tag_#{params[:id] || :all}_by_popularity"
    end
  end
end
