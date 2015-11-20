class Admin::ImagesController < Admin::BaseController
  after_filter :expire_show, :only => [:create, :update, :destroy]
  after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  cache_sweeper :project_sweeper, :tag_sweeper
      
  def index
    @project = Project.find(params[:project_id])
    @images = @project.images
  end

  def new
    @project = Project.find(params[:project_id])
    @image = @project.images.build
  end

  def edit
    @project = Project.find(params[:project_id])
    @image = @project.images.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @image = @project.images.new(image_params)
    @image.save!
    redirect_to edit_admin_project_image_path(@project,@image)
  end

  def update
    @project = Project.find(params[:project_id])
    @image = @project.images.find(params[:id])
    @image.update!(image_params)
    redirect_to edit_admin_project_image_path(@project,@image)
  end
  
  def destroy
    @project = Project.find(params[:project_id])
    @image = @project.images.find(params[:id])
    @image.destroy!
    redirect_to admin_project_images_path(@project)
  end
  
  def sort
    @project = Project.find(params[:project_id])
    @project.images.active.each do |i|
      i.position = params["image-list"].index(i.id.to_s)+1

      i.save
    end
    
    render :nothing => true
  end
  
  private 

  def image_params
    params.require(:image).permit(
      :name, :position, :description, :plan_x, :plan_y, :locator_angle,
      :sync_flickr, :flickr_id, :attachment, :plan_id, :project_id, :deleted_at
    )
  end
    
  #def pull_flickr
  #  load_object         # From R_C
  #  
  #  begin
  #    @image.pull_data_from_flickr
  #    @image.save!
  #  rescue XMLRPC::FaultException
  #    flash[:error] = "Error pulling from Flickr! (#{$!})"
  #  end
  #  
  #  flash[:notice] = "Data pulled from Flickr!"
  #  redirect_to edit_admin_project_image_path(@image.project, @image)    
  #end
  
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
