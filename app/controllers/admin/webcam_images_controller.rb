class Admin::WebcamImagesController < Admin::BaseController
  #after_filter :expire_show, :only => [:create, :update, :destroy]
  #after_filter :expire_thumbnails, :only => [:create, :update, :destroy]
  #after_filter :expire_tags, :only => [:create, :update, :destroy]
  
  #cache_sweeper :project_sweeper, :tag_sweeper
  
  def index
    @project = Project.find(params[:project_id])
    @webcam_images = @project.webcam_images.paginate(page: params[:page], per_page: 200)
  end

  def new
    @project = Project.find(params[:project_id])
    @webcam_image = @project.webcam_images.build
  end

  def edit
    @project = Project.find(params[:project_id])
    @webcam_image = @project.webcam_images.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @webcam_image = @project.webcam_images.new(webcam_image_params)
    @webcam_image.save!
    redirect_to edit_admin_project_webcam_image_path(@project,@webcam_image)
  end

  def update
    @project = Project.find(params[:project_id])
    @webcam_image = @project.webcam_images.find(params[:id])
    @webcam_image.update!(webcam_image_params)

    if params[:redirect_to].nil?
      redirect_to edit_admin_project_webcam_image_path(@project,@webcam_image)
    else 
      redirect_to params[:redirect_to]
    end
  end
  
  def destroy
    @project = Project.find(params[:project_id])
    @webcam_image = @project.webcam_images.find(params[:id])
    @webcam_image.destroy!

    respond_to do |format|
      format.html { redirect_to admin_project_webcam_images_path(@project) }
      format.js { render :nothing => true}
    end
  end
  
  private 

  def webcam_image_params
    params.require(:webcam_image).permit(
      :date, :source_url, :attachment, :project_id, :daily_image
    )
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
