class Admin::ImagesController < Admin::BaseController
  after_filter :expire_show, :only => [:create, :update, :destroy]
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  resource_controller
  
  belongs_to :project
  
  actions :all

  cache_sweeper :project_sweeper, :tag_sweeper
  
  update.after do
    push_data_to_flickr_from @image if (@image.sync_flickr == true || params[:sync_flicr] == true)
  end
      
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
  
  def pull_flickr
    load_object         # From R_C
    
    pull_data_from_flickr_to @image
    @image.save!
    
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
  
  def flickr
    @flickr ||= Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
  end
  
  def push_data_to_flickr_from(image)
    return false if image.flickr_id.blank?
    
    flickr.photos.setMeta( image.flickr_id, image.name, render_to_string( :partial => 'flickr_description', :locals => {:image => image}).gsub(/\r/, '') )
  end
  
  def pull_data_from_flickr_to(image)
    return false if image.flickr_id.blank?
    
    flickr_photo = flickr.photos.getInfo( image.flickr_id )
    image.name = flickr_photo.title
    image.description = flickr_photo.description unless flickr_photo.description.include? image.project.description[0..20]
    
    flash[:notice] = "Data pulled from Flickr!"
  end
end
